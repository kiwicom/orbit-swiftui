import SwiftUI
import UIKit

/// Orbit control that displays an editable text interface, a replacement for native `SwiftUI.TextField` component.
///
/// The component uses UIKit `UITextField` implementation to support these feature for older iOS versions:
/// - focus changes
/// - UITextField event handling
/// - full UITextField configuration
/// - font and text override
/// - larger and configurable touch area
///
/// The component is compatible with native `@FocusState` modifier to support focus changes in newer iOS versions.
public struct TextField: UIViewRepresentable, TextFieldBuildable {

    @Environment(\.identifier) private var identifier
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldBeginEditingIdentifiableAction) private var inputFieldBeginEditingIdentifiableAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.inputFieldEndEditingIdentifiableAction) private var inputFieldEndEditingIdentifiableAction
    @Environment(\.inputFieldFocus) private var inputFieldFocus
    @Environment(\.inputFieldReturnAction) private var inputFieldReturnAction
    @Environment(\.inputFieldReturnIdentifiableAction) private var inputFieldReturnIdentifiableAction
    @Environment(\.inputFieldShouldReturnAction) private var inputFieldShouldReturnAction
    @Environment(\.inputFieldShouldReturnIdentifiableAction) private var inputFieldShouldReturnIdentifiableAction
    @Environment(\.inputFieldShouldChangeCharactersAction) private var inputFieldShouldChangeCharactersAction
    @Environment(\.inputFieldShouldChangeCharactersIdentifiableAction) private var inputFieldShouldChangeCharactersIdentifiableAction
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textFontWeight) private var textFontWeight
    @Environment(\.textColor) private var textColor
    @Environment(\.textSize) private var textSize

    @Binding private var value: String
    private var prompt: String
    private var isSecureTextEntry: Bool
    private var state: InputState
    private var leadingPadding: CGFloat
    private var trailingPadding: CGFloat

    // Builder properties (keyboard related)
    var returnKeyType: UIReturnKeyType = .default
    var isAutocorrectionDisabled: Bool?
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var autocapitalizationType: UITextAutocapitalizationType = .sentences
    var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }

    public func makeUIView(context: Context) -> InsetableTextField {
        let textField = InsetableTextField()
        textField.delegate = context.coordinator

        textField.clearsOnBeginEditing = false
        textField.adjustsFontForContentSizeCategory = false
        textField.tintColor = .blueNormal

        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // Set initial text value to distinguish from binding updates
        textField.text = value

        return textField
    }

    public func updateUIView(_ uiView: InsetableTextField, context: Context) {
        // Prevent delegate call cycle when updating values from SwiftUI
        context.coordinator.isBeingUpdated = true

        uiView.updateIfNeeded(\.insets.left, to: leadingPadding)
        uiView.updateIfNeeded(\.insets.right, to: trailingPadding)
        uiView.updateIfNeeded(\.isSecureTextEntry, to: isSecureTextEntry)

        // Keyboard related
        uiView.updateIfNeeded(\.returnKeyType, to: returnKeyType)
        uiView.updateIfNeeded(\.keyboardType, to: keyboardType)
        uiView.updateIfNeeded(\.textContentType, to: textContentType)

        let autocorrectionType: UITextAutocorrectionType

        if let isAutocorrectionDisabled {
            autocorrectionType = isAutocorrectionDisabled ? .no : .yes
        } else {
            switch textContentType {
                case UITextContentType.emailAddress, UITextContentType.password, UITextContentType.newPassword:
                    // If not specified, disable autocomplete for these content types
                    autocorrectionType = .no
                default:
                    autocorrectionType = .default
            }
        }

        uiView.updateIfNeeded(\.autocorrectionType, to: autocorrectionType)
        uiView.updateIfNeeded(\.autocapitalizationType, to: autocapitalizationType)
        uiView.shouldDeleteBackwardAction = shouldDeleteBackwardAction

        if resolvedTextSize != context.coordinator.fontSize || resolvedTextWeight != context.coordinator.fontWeight {
            uiView.font = UIFont.orbit(size: resolvedTextSize, weight: resolvedTextWeight)
            context.coordinator.fontSize = resolvedTextSize
            context.coordinator.fontWeight = resolvedTextWeight
        }

        uiView.updateIfNeeded(\.textColor, to: resolvedTextColor(in: context.environment))
        uiView.updateIfNeeded(\.isEnabled, to: isEnabled)

        uiView.updateIfNeeded(
            \.attributedPlaceholder,
             to: .init(
                string: prompt,
                attributes: [
                    .foregroundColor: resolvedPromptColor(in: context.environment)
                ]
             )
        )

        // Check if the binding value is different to replace the text content
        if value != uiView.text {
            uiView.replace(withText: value)
        }

        // Become/Resign first responder if needed.
        // Only relevant to fields with identifier and Orbit focus modifier applied.
        // Not relevant for fields driven by iOS15+ @FocusState
        if let inputFieldFocus, let identifier {

            if let valueToUpdate = context.coordinator.valueToUpdate.first, valueToUpdate != inputFieldFocus.binding.wrappedValue {
                // Updated binding value from UIKit was not yet updated, ignoring
                context.coordinator.isBeingUpdated = false
                return
            }

            if uiView.isFirstResponder == false && inputFieldFocus.binding.wrappedValue == identifier {
                uiView.toggleKeyboardFocus(true, coordinator: context.coordinator)
                return
            } else if uiView.isFirstResponder && inputFieldFocus.binding.wrappedValue != identifier {
                uiView.toggleKeyboardFocus(false, coordinator: context.coordinator)
                return
            }
        }

        context.coordinator.isBeingUpdated = false
    }

    public func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(
            identifier: identifier,
            value: $value,
            inputFieldFocus: inputFieldFocus,
            inputFieldBeginEditingAction: inputFieldBeginEditingAction,
            inputFieldBeginEditingIdentifiableAction: inputFieldBeginEditingIdentifiableAction,
            inputFieldEndEditingAction: inputFieldEndEditingAction,
            inputFieldEndEditingIdentifiableAction: inputFieldEndEditingIdentifiableAction,
            inputFieldReturnAction: inputFieldReturnAction,
            inputFieldReturnIdentifiableAction: inputFieldReturnIdentifiableAction,
            inputFieldShouldReturnAction: inputFieldShouldReturnAction,
            inputFieldShouldReturnIdentifiableAction: inputFieldShouldReturnIdentifiableAction,
            inputFieldShouldChangeCharactersAction: inputFieldShouldChangeCharactersAction,
            inputFieldShouldChangeCharactersIdentifiableAction: inputFieldShouldChangeCharactersIdentifiableAction
        )
    }

    private func resolvedTextColor(in environment: EnvironmentValues) -> UIColor {
        if #available(iOS 14, *), environment.redactionReasons.isEmpty == false {
            return .clear
        }

        return isEnabled ? (textColor ?? state.textColor).uiColor : .cloudDarkActive
    }

    private func resolvedPromptColor(in environment: EnvironmentValues) -> UIColor {
        if #available(iOS 14, *), environment.redactionReasons.isEmpty == false {
            return .clear
        }

        return isEnabled ? state.placeholderColor.uiColor : .cloudDarkActive
    }

    private var resolvedTextSize: CGFloat {
        (textSize ?? Text.Size.normal.value) * sizeCategory.ratio
    }

    private var resolvedTextWeight: UIFont.Weight {
        (textFontWeight ?? .regular).uiKit
    }
}

// MARK: - Inits
public extension TextField {

    /// Creates Orbit ``TextField`` wrapper over UITextField, used in ``InputField``.
    init(
        value: Binding<String>,
        prompt: String = "",
        isSecureTextEntry: Bool = false,
        state: InputState = .default,
        leadingPadding: CGFloat = 0,
        trailingPadding: CGFloat = 0
    ) {
        self._value = value
        self.prompt = prompt
        self.isSecureTextEntry = isSecureTextEntry
        self.state = state
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
    }
}

// MARK: - Types

/// The result of Orbit `inputFieldShouldChangeCharactersAction`.
public enum InputFieldShouldChangeResult {
    /// Specifies that proposed changes should be accepted.
    case accept
    /// Specifies that proposed changes should not be accepted, making the `InputField` keeping the previous value.
    case reject
    /// Specifies that proposed changes should not be accepted and the current value of `InputField` should be replaced with proposed `replacementValue` instead.
    case replace(_ replacementValue: String)
}

private extension InsetableTextField {

    @discardableResult
    func updateIfNeeded<Value: Equatable>(_ path: ReferenceWritableKeyPath<InsetableTextField, Value>, to value: Value) -> Self {
        if value != self[keyPath: path] {
            self[keyPath: path] = value
        }
        return self
    }
}

// MARK: - Previews
struct TextFieldPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            alignment
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: .medium) {
            Group {
                StateWrapper("") { value in
                    TextField(value: value, prompt: "Enter value", isSecureTextEntry: true)
                }
                StateWrapper("value") { value in
                    TextField(value: value, prompt: "Enter value", isSecureTextEntry: true)
                }
                StateWrapper("value") { value in
                    TextField(value: value, prompt: "Enter value", isSecureTextEntry: false)
                }
            }
            .border(.black, width: .hairline)
        }
        .previewDisplayName()
    }

    static var alignment: some View {
        VStack(spacing: .medium) {
            Group {
                HStack(alignment: .firstTextBaseline) {
                    Text("Label")
                    TextField(value: .constant("Value"))
                }

                HStack(alignment: .firstTextBaseline) {
                    Text("Label")
                    TextField(value: .constant("Value"))
                }
                .textSize(custom: 40)
                .textColor(.blueDark)
                .textFontWeight(.black)
            }
            .overlay(
                Color.redNormal
                    .frame(height: .hairline)
                ,
                alignment: .centerFirstTextBaseline
            )
        }
        .previewDisplayName()
    }
}

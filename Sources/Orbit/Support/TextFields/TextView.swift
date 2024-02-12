import SwiftUI
import UIKit

/// Orbit control that displays a multiline editable text interface, a replacement for the native multiline `SwiftUI.TextField` component.
///
/// The component uses UIKit `UITextView` implementation to support these feature for older iOS versions:
/// - focus changes
/// - UITextField event handling
/// - full UITextField configuration
/// - font and text override
/// - larger and configurable touch area
///
/// The component is compatible with native `@FocusState` modifier to support focus changes in newer iOS versions.
public struct TextView: UIViewRepresentable, TextFieldBuildable {

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
    @Environment(\.lineLimit) private var lineLimit

    @Binding private var value: String
    @Binding private var calculatedHeight: CGFloat
    private var prompt: String
    private var state: InputState
    private var insets: UIEdgeInsets
    
    // Builder properties (keyboard related)
    var returnKeyType: UIReturnKeyType = .done
    var isAutocorrectionDisabled: Bool?
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var autocapitalizationType: UITextAutocapitalizationType = .sentences
    var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }

    public func makeUIView(context: Context) -> InsetableTextView {
        let textView = InsetableTextView()
        textView.insets = insets
        textView.delegate = context.coordinator

        textView.adjustsFontForContentSizeCategory = false
        textView.tintColor = .blueNormal

        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // Set initial text value to distinguish from binding updates
        textView.text = value
        
        return textView
    }

    public func updateUIView(_ uiView: InsetableTextView, context: Context) {
        // Prevent delegate call cycle when updating values from SwiftUI
        context.coordinator.isBeingUpdated = true

        uiView.updateIfNeeded(\.contentInset, to: insets)
        uiView.updateIfNeeded(\.numberOfLines, to: lineLimit ?? 0)

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
            uiView.promptLabel.font = uiView.font 
            context.coordinator.fontSize = resolvedTextSize
            context.coordinator.fontWeight = resolvedTextWeight
        }

        uiView.updateIfNeeded(\.textColor, to: isEnabled ? (textColor ?? state.textColor).uiColor : .cloudDarkActive)
        uiView.updateIfNeeded(\.isEditable, to: isEnabled)
        uiView.updateIfNeeded(\.prompt, to: prompt)
        uiView.updateIfNeeded(\.promptLabel.textColor, to: isEnabled ? state.placeholderColor.uiColor : .cloudDarkActive)
        
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
        
        recalculateHeight(view: uiView)

        context.coordinator.isBeingUpdated = false
    }
    
    func recalculateHeight(view: UIView) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if 10 < newSize.height && calculatedHeight != newSize.height {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = newSize.height
            }
        } else if 10 >= newSize.height && calculatedHeight != 10 {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = 10
            }
        }
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

    private var resolvedTextSize: CGFloat {
        (textSize ?? Text.Size.normal.value) * sizeCategory.ratio
    }

    private var resolvedTextWeight: UIFont.Weight {
        (textFontWeight ?? .regular).uiKit
    }
}

// MARK: - Inits
public extension TextView {

    /// Creates Orbit ``TextView`` wrapper over `UITextView`. The component is used in ``Textarea`` component.
    init(
        value: Binding<String>,
        calculatedHeight: Binding<CGFloat>,
        prompt: String = "",
        state: InputState = .default,
        insets: UIEdgeInsets = .zero
    ) {
        self._value = value
        self._calculatedHeight = calculatedHeight
        self.prompt = prompt
        self.state = state
        self.insets = insets
    }
}

private extension InsetableTextView {

    @discardableResult
    func updateIfNeeded<Value: Equatable>(_ path: ReferenceWritableKeyPath<InsetableTextView, Value>, to value: Value) -> Self {
        if value != self[keyPath: path] {
            self[keyPath: path] = value
        }
        return self
    }
}


// MARK: - Previews
struct TextViewPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            alignment
            lineLimit
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: .medium) {
            Group {
//                TextView(value: .constant(""), calculatedHeight: <#T##Binding<CGFloat>#> prompt: "Disabled")
//                    .disabled(true)
//                    .frame(width: 50, height: 50)
                
//                StateWrapper("") { $value in
//                    TextView(value: $value, prompt: "Enter value")
//                        .frame(height: 50)
//                }
//                StateWrapper("value") { $value in
//                    TextView(value: $value, prompt: "Enter value")
//                        .frame(width: 200, height: 100)
//                }
//                StateWrapper("value") { $value in
//                    TextView(value: $value, prompt: "Enter value")
//                }
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
                }

                HStack(alignment: .firstTextBaseline) {
                    Text("Label")
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
    
    static var lineLimit: some View {
        VStack(spacing: .medium) {
            Group {
                StateWrapper(CGFloat(100)) { $height in
                    TextView(value: .constant(""), calculatedHeight: $height, prompt: "Disabled")
                        .disabled(true)
                        .frame(height: height)
                }
                
                StateWrapper(CGFloat(100)) { $height in
                    StateWrapper("value") { $value in
                        TextView(value: $value, calculatedHeight: $height, prompt: "Enter value")
                            .frame(height: height)
                    }
                }
            }
            .lineLimit(3)
            .border(.black, width: .hairline)
        }
        .previewDisplayName()
    }
}

import SwiftUI
import UIKit

/// Orbit wrapper over `UITextField` with larger touch area and action handling.
public struct TextField: UIViewRepresentable, TextFieldBuildable {

    @Environment(\.identifier) private var identifier
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldBeginEditingIdentifiableAction) private var inputFieldBeginEditingIdentifiableAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.inputFieldEndEditingIdentifiableAction) private var inputFieldEndEditingIdentifiableAction
    @Environment(\.inputFieldFocus) private var inputFieldFocus
    @Environment(\.inputFieldShouldReturnAction) private var inputFieldShouldReturnAction
    @Environment(\.inputFieldShouldReturnIdentifiableAction) private var inputFieldShouldReturnIdentifiableAction
    @Environment(\.inputFieldShouldChangeCharactersAction) private var inputFieldShouldChangeCharactersAction
    @Environment(\.inputFieldShouldChangeCharactersIdentifiableAction) private var inputFieldShouldChangeCharactersIdentifiableAction

    @Binding private var value: String
    private var prompt: String
    private var isSecureTextEntry: Bool
    private var font: UIFont
    private var state: InputState
    private var leadingPadding: CGFloat
    private var trailingPadding: CGFloat

    // Builder properties (keyboard related)
    var returnKeyType: UIReturnKeyType = .default
    var isAutocorrectionDisabled: Bool? = nil
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
        // Prevent unwanted delegate calls when updating values from bindings
        context.coordinator.isBeingUpdated = true

        uiView.insets.left = leadingPadding
        uiView.insets.right = trailingPadding
        uiView.isSecureTextEntry = isSecureTextEntry

        // Keyboard related
        uiView.returnKeyType = returnKeyType
        uiView.keyboardType = keyboardType
        uiView.textContentType = textContentType

        if let isAutocorrectionDisabled {
            uiView.autocorrectionType = isAutocorrectionDisabled ? .no : .yes
        } else {
            switch textContentType {
                case UITextContentType.emailAddress, UITextContentType.password, UITextContentType.newPassword:
                    // If not specified, disable autocomplete for these content types
                    uiView.autocorrectionType = .no
                default:
                    uiView.autocorrectionType = .default
            }
        }

        uiView.autocapitalizationType = autocapitalizationType
        uiView.shouldDeleteBackwardAction = shouldDeleteBackwardAction

        uiView.font = font
        uiView.textColor = isEnabled ? state.textColor.uiColor : .cloudDarkActive
        uiView.isEnabled = isEnabled

        uiView.attributedPlaceholder = .init(
            string: prompt,
            attributes: [
                .foregroundColor: isEnabled ? state.placeholderColor.uiColor : .cloudDarkActive
            ]
        )

        // Check if the binding value is different to replace the text content
        if value != uiView.text {
            uiView.replace(withText: value)
        }

        // Become/Resign first responder if needed
        if let inputFieldFocus, let value = identifier {
            switch (uiView.isFirstResponder, inputFieldFocus.binding.wrappedValue == value) {
                case (false, true):
                    // Needs to be dispatched
                    Task { @MainActor in
                        _ = uiView.becomeFirstResponder()
                        context.coordinator.isBeingUpdated = false
                    }
                    return
                case (true, false):
                    _ = uiView.resignFirstResponder()
                default:
                    break
            }
        }

        context.coordinator.isBeingUpdated = false
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            identifier: identifier,
            value: $value,
            inputFieldFocus: inputFieldFocus,
            inputFieldBeginEditingAction: inputFieldBeginEditingAction,
            inputFieldBeginEditingIdentifiableAction: inputFieldBeginEditingIdentifiableAction,
            inputFieldEndEditingAction: inputFieldEndEditingAction,
            inputFieldEndEditingIdentifiableAction: inputFieldEndEditingIdentifiableAction,
            inputFieldShouldReturnAction: inputFieldShouldReturnAction,
            inputFieldShouldReturnIdentifiableAction: inputFieldShouldReturnIdentifiableAction,
            inputFieldShouldChangeCharactersAction: inputFieldShouldChangeCharactersAction,
            inputFieldShouldChangeCharactersIdentifiableAction: inputFieldShouldChangeCharactersIdentifiableAction
        )
    }

    public final class Coordinator: NSObject, UITextFieldDelegate, ObservableObject {

        let identifier: AnyHashable?
        @Binding var value: String
        let inputFieldFocus: InputFieldFocus?
        let inputFieldBeginEditingAction: () -> Void
        let inputFieldBeginEditingIdentifiableAction: (AnyHashable) -> Void
        let inputFieldEndEditingAction: () -> Void
        let inputFieldEndEditingIdentifiableAction: (AnyHashable) -> Void
        let inputFieldShouldReturnAction: (() -> Bool)?
        let inputFieldShouldReturnIdentifiableAction: ((AnyHashable) -> Bool)?
        let inputFieldShouldChangeCharactersAction: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)?
        let inputFieldShouldChangeCharactersIdentifiableAction: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)?

        // Required to distinguish SwiftUI (`updateUIView`) from UIKit change
        fileprivate var isBeingUpdated = false

        init(
            identifier: AnyHashable?,
            value: Binding<String>,
            inputFieldFocus: InputFieldFocus?,
            inputFieldBeginEditingAction: @escaping () -> Void,
            inputFieldBeginEditingIdentifiableAction: @escaping (AnyHashable) -> Void,
            inputFieldEndEditingAction: @escaping () -> Void,
            inputFieldEndEditingIdentifiableAction: @escaping (AnyHashable) -> Void,
            inputFieldShouldReturnAction: (() -> Bool)?,
            inputFieldShouldReturnIdentifiableAction: ((AnyHashable) -> Bool)?,
            inputFieldShouldChangeCharactersAction: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)?,
            inputFieldShouldChangeCharactersIdentifiableAction: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)?
        ) {
            self.identifier = identifier
            self._value = value
            self.inputFieldFocus = inputFieldFocus
            self.inputFieldBeginEditingAction = inputFieldBeginEditingAction
            self.inputFieldBeginEditingIdentifiableAction = inputFieldBeginEditingIdentifiableAction
            self.inputFieldEndEditingAction = inputFieldEndEditingAction
            self.inputFieldEndEditingIdentifiableAction = inputFieldEndEditingIdentifiableAction
            self.inputFieldShouldReturnAction = inputFieldShouldReturnAction
            self.inputFieldShouldReturnIdentifiableAction = inputFieldShouldReturnIdentifiableAction
            self.inputFieldShouldChangeCharactersAction = inputFieldShouldChangeCharactersAction
            self.inputFieldShouldChangeCharactersIdentifiableAction = inputFieldShouldChangeCharactersIdentifiableAction
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            if isBeingUpdated { return }

            Task { @MainActor in
                if let inputFieldFocus {
                    inputFieldFocus.binding.wrappedValue = identifier
                }

                inputFieldBeginEditingAction()

                if let identifier {
                    inputFieldBeginEditingIdentifiableAction(identifier)
                }
            }
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            if isBeingUpdated { return }

            Task { @MainActor in
                if let inputFieldFocus {
                    inputFieldFocus.binding.wrappedValue = nil
                }

                inputFieldEndEditingAction()

                if let identifier {
                    inputFieldEndEditingIdentifiableAction(identifier)
                }
            }
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if isBeingUpdated { return true }

            let shouldReturn: Bool

            if let inputFieldShouldReturnIdentifiableAction, let identifier {
                shouldReturn = inputFieldShouldReturnIdentifiableAction(identifier)
            } else if let inputFieldShouldReturnAction {
                shouldReturn = inputFieldShouldReturnAction()
            } else {
                shouldReturn = true
            }

            if shouldReturn {
                textField.resignFirstResponder()
            }

            return shouldReturn
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if isBeingUpdated { return true }

            let text = ((textField.text ?? "") as NSString)
            let result: InputFieldShouldChangeResult

            if let inputFieldShouldChangeCharactersIdentifiableAction, let identifier {
                result = inputFieldShouldChangeCharactersIdentifiableAction(identifier, text, range, string)
            } else if let inputFieldShouldChangeCharactersAction {
                result = inputFieldShouldChangeCharactersAction(text, range, string)
            } else {
                result = .accept
            }

            switch result {
                case .accept:
                    return true
                case .replace(let modifiedValue):
                    // Refuse the proposed change, replace the text with modified value
                    textField.text = modifiedValue
                    return false
                case .reject:
                    return false
            }
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            if isBeingUpdated { return }

            let newValue = textField.text ?? ""

            if value != newValue {
                // This is a safer place to report the actual value, as it can be modified by system silently.
                // Example: `emailAddress` type being hijacked by system when using autocomplete
                // https://github.com/lionheart/openradar-mirror/issues/18086
                value = newValue
            }
        }
    }
}

// MARK: - Inits
public extension TextField {

    /// Creates Orbit TextField wrapper over UITextField, used internally in `InputField`.
    init(
        value: Binding<String>,
        prompt: String = "",
        isSecureTextEntry: Bool = false,
        font: UIFont = .orbit,
        state: InputState = .default,
        leadingPadding: CGFloat = 0,
        trailingPadding: CGFloat = 0
    ) {
        self._value = value
        self.prompt = prompt
        self.isSecureTextEntry = isSecureTextEntry
        self.font = font
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

// MARK: - Previews
struct TextFieldPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
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
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}

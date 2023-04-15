import SwiftUI
import UIKit

// Wrapper over UITextField with larger touch area.
struct TextField: UIViewRepresentable {

    @Environment(\.identifier) private var identifier
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldBeginEditingIdentifiableAction) private var inputFieldBeginEditingIdentifiableAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.inputFieldEndEditingIdentifiableAction) private var inputFieldEndEditingIdentifiableAction
    @Environment(\.inputFieldShouldReturnAction) private var inputFieldShouldReturnAction
    @Environment(\.inputFieldShouldReturnIdentifiableAction) private var inputFieldShouldReturnIdentifiableAction
    @Environment(\.inputFieldShouldChangeCharactersAction) private var inputFieldShouldChangeCharactersAction
    @Environment(\.inputFieldShouldChangeCharactersIdentifiableAction) private var inputFieldShouldChangeCharactersIdentifiableAction

    @Binding var value: String

    var prompt = ""
    var isSecureTextEntry: Bool = false

    // Keyboard related
    var returnKeyType: UIReturnKeyType = .default
    var isAutocorrectionDisabled: Bool = true
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var autocapitalizationType: UITextAutocapitalizationType = .sentences

    var font: UIFont = .orbit
    var state: InputState = .default
    var leadingPadding: CGFloat = 0
    var trailingPadding: CGFloat = 0

    func makeUIView(context: Context) -> InsetableTextField {
        let textField = InsetableTextField()
        textField.delegate = context.coordinator

        textField.clearsOnBeginEditing = false
        textField.adjustsFontForContentSizeCategory = false

        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textField
    }

    func updateUIView(_ uiView: InsetableTextField, context: Context) {
        uiView.insets.left = leadingPadding
        uiView.insets.right = trailingPadding
        uiView.isSecureTextEntry = isSecureTextEntry

        // Keyboard related
        uiView.returnKeyType = returnKeyType
        uiView.autocorrectionType = isAutocorrectionDisabled ? .no : .default
        uiView.keyboardType = keyboardType
        uiView.textContentType = textContentType
        uiView.autocapitalizationType = autocapitalizationType

        uiView.font = font
        uiView.textColor = isEnabled ? state.textColor.uiColor : .cloudDarkActive
        uiView.isEnabled = isEnabled

        uiView.attributedPlaceholder = .init(
            string: prompt,
            attributes: [
                .foregroundColor: isEnabled ? state.placeholderColor.uiColor : .cloudDarkActive
            ]
        )

        guard uiView.isFirstResponder else {
            uiView.text = value
            return
        }

        // Prevent UITextField erasing the current value
        let isBeginEditing = uiView.isSecureTextEntry && uiView.text == value
        let isTextModifiedOutsideTextField = value != context.coordinator.textFieldValue
        if isBeginEditing || isTextModifiedOutsideTextField {
            uiView.text?.removeAll()
            uiView.insertText(value)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            identifier: identifier,
            value: $value,
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

    class Coordinator: NSObject, UITextFieldDelegate {

        let identifier: AnyHashable?
        @Binding var value: String
        let inputFieldBeginEditingAction: () -> Void
        let inputFieldBeginEditingIdentifiableAction: (AnyHashable) -> Void
        let inputFieldEndEditingAction: () -> Void
        let inputFieldEndEditingIdentifiableAction: (AnyHashable) -> Void
        let inputFieldShouldReturnAction: (() -> Bool)?
        let inputFieldShouldReturnIdentifiableAction: ((AnyHashable) -> Bool)?
        let inputFieldShouldChangeCharactersAction: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)?
        let inputFieldShouldChangeCharactersIdentifiableAction: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)?

        private(set) lazy var textFieldValue: String = value {
            didSet {
                value = textFieldValue
            }
        }

        init(
            identifier: AnyHashable?,
            value: Binding<String>,
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
            self.inputFieldBeginEditingAction = inputFieldBeginEditingAction
            self.inputFieldBeginEditingIdentifiableAction = inputFieldBeginEditingIdentifiableAction
            self.inputFieldEndEditingAction = inputFieldEndEditingAction
            self.inputFieldEndEditingIdentifiableAction = inputFieldEndEditingIdentifiableAction
            self.inputFieldShouldReturnAction = inputFieldShouldReturnAction
            self.inputFieldShouldReturnIdentifiableAction = inputFieldShouldReturnIdentifiableAction
            self.inputFieldShouldChangeCharactersAction = inputFieldShouldChangeCharactersAction
            self.inputFieldShouldChangeCharactersIdentifiableAction = inputFieldShouldChangeCharactersIdentifiableAction
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            inputFieldBeginEditingAction()

            if let identifier {
                inputFieldBeginEditingIdentifiableAction(identifier)
            }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            textFieldValue = textField.text ?? ""

            inputFieldEndEditingAction()

            if let identifier {
                inputFieldEndEditingIdentifiableAction(identifier)
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
                    // Accept the proposed change
                    textFieldValue = text.replacingCharacters(in: range, with: string)
                    return true
                case .replace(let modifiedTextFieldValue):
                    // Refuse the proposed change, replace the textfield with modified value
                    textField.text = modifiedTextFieldValue

                    // Dispatch is required to apply the modified change
                    DispatchQueue.main.async { [weak self] in
                        self?.textFieldValue = modifiedTextFieldValue
                    }
                    return false
                case .reject:
                    return false
            }
        }
    }
}

// MARK: - Types

/// UITextField with a larger touch area.
class InsetableTextField: UITextField {

    // .small size would cause a resize issue in secure mode
    var insets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).inset(by: insets)
    }
}

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

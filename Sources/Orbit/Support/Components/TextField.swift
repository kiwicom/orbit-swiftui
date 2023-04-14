import SwiftUI
import UIKit

// Wrapper over UITextField with larger touch area.
struct TextField: UIViewRepresentable {

    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction

    @Binding var value: String

    var prompt = ""
    var isSecureTextEntry: Bool = false

    // Keyboard related
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
            value: $value,
            inputFieldBeginEditingAction: inputFieldBeginEditingAction,
            inputFieldEndEditingAction: inputFieldEndEditingAction
        )
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var value: String
        let inputFieldBeginEditingAction: () -> Void
        let inputFieldEndEditingAction: () -> Void

        private(set) lazy var textFieldValue: String = value {
            didSet {
                value = textFieldValue
            }
        }

        init(
            value: Binding<String>,
            inputFieldBeginEditingAction: @escaping () -> Void,
            inputFieldEndEditingAction: @escaping () -> Void
        ) {
            self._value = value
            self.inputFieldBeginEditingAction = inputFieldBeginEditingAction
            self.inputFieldEndEditingAction = inputFieldEndEditingAction
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            inputFieldBeginEditingAction()
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }

            textFieldValue = textField.text ?? ""
            inputFieldEndEditingAction()
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            textFieldValue = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            return true
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

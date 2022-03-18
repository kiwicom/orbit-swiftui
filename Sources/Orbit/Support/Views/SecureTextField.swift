import SwiftUI
import UIKit

struct SecureTextFieldStyle {
    let textContentType: UITextContentType?
    let autocapitalization: UITextAutocapitalizationType
    let keyboardType: UIKeyboardType
    let font: UIFont
    let state: InputState = .default
}

struct SecureTextField: UIViewRepresentable {
    typealias UIViewType = UITextField

    @Binding var text: String
    @Binding var isSecured: Bool
    @Binding var isEditing: Bool
    let style: SecureTextFieldStyle

    func makeUIView(context: Context) -> UITextField {
        let textFied = UITextField()
        textFied.autocorrectionType = .no
        textFied.delegate = context.coordinator

        textFied.text = text
        textFied.isSecureTextEntry = isSecured
        textFied.textContentType = style.textContentType
        textFied.autocapitalizationType = style.autocapitalization
        textFied.keyboardType = style.keyboardType
        textFied.font = style.font
        textFied.textColor = style.state.textUIColor
        textFied.clearsOnBeginEditing = false

        if isEditing && textFied.canBecomeFirstResponder {
            textFied.becomeFirstResponder()
        }

        return textFied
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.isSecureTextEntry = isSecured

        if uiView.isSecureTextEntry && uiView.text == text {
            // Workaround. Without it, UITextField will erase it's own current value on frist input
            uiView.text?.removeAll()
            uiView.insertText(text)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isEditing: Binding<Bool>

        init(text: Binding<String>, isEditing: Binding<Bool>) {
            self.text = text
            self.isEditing = isEditing
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            endEditing(textField)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            endEditing(textField)
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            if let input = textField.text, let specialRange = Range(range, in: input) {
                text.wrappedValue.replaceSubrange(specialRange, with: string)
            }
            return true
        }

        private func endEditing(_ textField: UITextField) {
            textField.resignFirstResponder()
            text.wrappedValue = textField.text ?? ""
            isEditing.wrappedValue = false
        }
    }
}

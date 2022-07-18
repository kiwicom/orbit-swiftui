import SwiftUI
import UIKit

struct SecureTextFieldStyle {
    // FIXME: support autocapitalization to match InputField style
    let textContentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let font: UIFont
    let state: InputState
}

struct SecureTextField: UIViewRepresentable {
    typealias UIViewType = UITextField

    @Binding var text: String
    @Binding var isSecured: Bool
    @Binding var isEditing: Bool

    var style: SecureTextFieldStyle = .init(textContentType: nil, keyboardType: .default, font: .orbit, state: .default)
    var onEditingChanged: (Bool) -> Void = { _ in }
    var onCommit = {}

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.delegate = context.coordinator

        textField.text = text
        textField.isSecureTextEntry = isSecured
        textField.textContentType = style.textContentType
        textField.keyboardType = style.keyboardType
        textField.font = style.font
        textField.textColor = style.state.textUIColor
        textField.clearsOnBeginEditing = false
        textField.isEnabled = style.state != .disabled
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        if isEditing && textField.canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.isSecureTextEntry = isSecured

        guard uiView.isFirstResponder else {
            uiView.text = text
            return
        }

        // Workaround. Without it, UITextField will erase it's own current value on frist input
        let didUserJustDidStartEditing = uiView.isSecureTextEntry && uiView.text == text
        let isTextModifiedOutsideTextField = text != context.coordinator.textFieldInput
        if didUserJustDidStartEditing || isTextModifiedOutsideTextField {
            uiView.text?.removeAll()
            uiView.insertText(text)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing, onEditingChanged: onEditingChanged, onCommit: onCommit)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isEditing: Binding<Bool>
        let onEditingChanged: (Bool) -> Void
        let onCommit: () -> Void

        private(set) lazy var textFieldInput: String = text.wrappedValue

        init(text: Binding<String>,
             isEditing: Binding<Bool>,
             onEditingChanged: @escaping (Bool) -> Void,
             onCommit: @escaping () -> Void
        ) {
            self.text = text
            self.isEditing = isEditing
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            isEditing.wrappedValue = true
            onEditingChanged(isEditing.wrappedValue)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }

            text.wrappedValue = textField.text ?? ""
            textFieldInput = text.wrappedValue
            onCommit()

            isEditing.wrappedValue = false
            onEditingChanged(isEditing.wrappedValue)
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            text.wrappedValue = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            textFieldInput = text.wrappedValue
            
            return true
        }
    }
}

// MARK: - Previews
struct SecureTextFieldPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            SecureTextField(text: .constant(""), isSecured: .constant(true), isEditing: .constant(false))
            SecureTextField(text: .constant("value"), isSecured: .constant(true), isEditing: .constant(false))
            SecureTextField(text: .constant("value"), isSecured: .constant(false), isEditing: .constant(false))
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI
import UIKit

struct SecureTextFieldStyle {
    // FIXME: support autocapitalization to match InputField style
    let textContentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let font: UIFont
    let state: InputState
}

public struct SecureTextField: UIViewRepresentable {
    public typealias UIViewType = UITextField

    @Binding var text: String
    @ObservedObject var innerState: InputInnerState

    var style: SecureTextFieldStyle = .init(textContentType: nil, keyboardType: .default, font: .orbit, state: .default)
    var onEditingChanged: (Bool) -> Void = { _ in }
    var onCommit = {}

    public  func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.delegate = context.coordinator

        textField.text = text
        textField.isSecureTextEntry = innerState.isSecureTextEntry
        textField.textContentType = style.textContentType
        textField.keyboardType = style.keyboardType
        textField.font = style.font
        textField.textColor = style.state.textUIColor
        textField.clearsOnBeginEditing = false
        textField.isEnabled = style.state != .disabled
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)

        if innerState.isEditing && textField.canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }

        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.isSecureTextEntry = innerState.isSecureTextEntry

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

    public func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $innerState.isEditing, onEditingChanged: onEditingChanged, onCommit: onCommit)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
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

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            isEditing.wrappedValue = true
            onEditingChanged(isEditing.wrappedValue)
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }

            text.wrappedValue = textField.text ?? ""
            textFieldInput = text.wrappedValue
            onCommit()

            isEditing.wrappedValue = false
            onEditingChanged(isEditing.wrappedValue)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
            SecureTextField(text: .constant(""), innerState: .init(isEditing: false, isSecureTextEntry: true))
            SecureTextField(text: .constant("value"), innerState: .init(isEditing: false, isSecureTextEntry: true))
            SecureTextField(text: .constant("value"), innerState: .init(isEditing: false, isSecureTextEntry: false))
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}

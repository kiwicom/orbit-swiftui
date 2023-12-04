import UIKit

/// Orbit `UITextField` wrapper with a larger touch area.
public class InsetableTextField: UITextField {

    // Using .small vertical padding would cause resize issue in secure mode
    public var insets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
    public var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard Thread.isMainThread else { return .zero }
        return super.textRect(forBounds: bounds).inset(by: insets)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard Thread.isMainThread else { return .zero }
        return super.textRect(forBounds: bounds).inset(by: insets)
    }

    public override func deleteBackward() {
        if shouldDeleteBackwardAction(text ?? "") {
            super.deleteBackward()
        }
    }

    public override var isSecureTextEntry: Bool {
        didSet {
            if isSecureTextEntry, oldValue == false, isFirstResponder, let text {
                // Prevent erasing the current value
                replace(withText: text, keepingCapacity: true)
            }
        }
    }

    public override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()

        // Prevent erasing the current value
        if isSecureTextEntry, let text {
            replace(withText: text, keepingCapacity: true)
        }
        
        return success
    }

    func replace(withText text: String, keepingCapacity: Bool = false) {
        self.text?.removeAll(keepingCapacity: keepingCapacity)
        insertText(text)
    }
}

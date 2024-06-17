import UIKit

/// Orbit `UITextField` wrapper with a larger touch area.
public class InsetableTextField: UITextField {

    /// Insets for setting overall control touch area.
    public var insets = UIEdgeInsets(top: .small, left: 0, bottom: .small, right: 0) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Additonal spacing between insets and keyboard.
    public var keyboardSpacing: CGFloat = .medium {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }
    
    /// Insets for overall control touch area and native keyboard avoidance.
    public var resolvedInsets: UIEdgeInsets {
        .init(
            top: insets.top, 
            left: insets.left, 
            bottom: insets.bottom + keyboardSpacing, 
            right: insets.right
        )
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard Thread.isMainThread else { return .zero }
        return super.textRect(forBounds: bounds).inset(by: resolvedInsets)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard Thread.isMainThread else { return .zero }
        return super.textRect(forBounds: bounds).inset(by: resolvedInsets)
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

import SwiftUI

/// Coordinator that manages Orbit text input components ``InputField`` and ``Textarea``.
public final class TextFieldCoordinator: NSObject, ObservableObject {

    static var textFieldToBecomeResponder: UITextInput?
    static var coordinatorToBecomeResponder: TextFieldCoordinator?
    static var textFieldToResignResponder: UITextInput?
    static var coordinatorToResignResponder: TextFieldCoordinator?

    static func debounceBecomeResponder(coordinator: TextFieldCoordinator) {
        coordinatorToBecomeResponder = coordinator
        debounceResponderUpdate()
    }

    static func debounceResignResponder(coordinator: TextFieldCoordinator) {
        coordinatorToResignResponder = coordinator
        debounceResponderUpdate()
    }

    static func debounceResponderUpdate() {
        responderDebounceTimer?.invalidate()

        if textFieldToResignResponder != nil && textFieldToBecomeResponder != nil {
            switchResponders()
        } else {
            responderDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { _ in
                switchResponders()
            }
        }
    }

    static func switchResponders() {
        // The inverted order is important for keyboard to stay fixed when switching responders
        _ = textFieldToBecomeResponder?.textInputView?.superview?.becomeFirstResponder()
        textFieldToBecomeResponder = nil
        _ = textFieldToResignResponder?.textInputView?.superview?.resignFirstResponder()
        textFieldToResignResponder = nil

        coordinatorToResignResponder?.onEndEditing(updateBinding: false)
        coordinatorToResignResponder?.isBeingUpdated = false
        coordinatorToResignResponder = nil

        coordinatorToBecomeResponder?.onBeginEditing(updateBinding: false)
        coordinatorToBecomeResponder?.isBeingUpdated = false
        coordinatorToBecomeResponder = nil
    }

    static var responderDebounceTimer: Timer?

    @Binding var value: String
    var valueToUpdate = [AnyHashable?]()

    var fontSize: CGFloat = 0
    var fontWeight: UIFont.Weight = .regular

    let identifier: AnyHashable?
    let inputFieldFocus: InputFieldFocus?
    let inputFieldBeginEditingAction: () -> Void
    let inputFieldBeginEditingIdentifiableAction: (AnyHashable) -> Void
    let inputFieldEndEditingAction: () -> Void
    let inputFieldEndEditingIdentifiableAction: (AnyHashable) -> Void
    let inputFieldReturnAction: () -> Void
    let inputFieldReturnIdentifiableAction: (AnyHashable) -> Void
    let inputFieldShouldReturnAction: (() -> Bool)?
    let inputFieldShouldReturnIdentifiableAction: ((AnyHashable) -> Bool)?
    let inputFieldShouldChangeCharactersAction: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)?
    let inputFieldShouldChangeCharactersIdentifiableAction: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)?

    // Required to distinguish delegate calls as a result of changes from SwiftUI (`updateUIView`)
    // from changes coming directly from UIKit.
    var isBeingUpdated = false

    init(
        identifier: AnyHashable?,
        value: Binding<String>,
        inputFieldFocus: InputFieldFocus?,
        inputFieldBeginEditingAction: @escaping () -> Void,
        inputFieldBeginEditingIdentifiableAction: @escaping (AnyHashable) -> Void,
        inputFieldEndEditingAction: @escaping () -> Void,
        inputFieldEndEditingIdentifiableAction: @escaping (AnyHashable) -> Void,
        inputFieldReturnAction: @escaping () -> Void,
        inputFieldReturnIdentifiableAction: @escaping (AnyHashable) -> Void,
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
        self.inputFieldReturnAction = inputFieldReturnAction
        self.inputFieldReturnIdentifiableAction = inputFieldReturnIdentifiableAction
        self.inputFieldShouldReturnAction = inputFieldShouldReturnAction
        self.inputFieldShouldReturnIdentifiableAction = inputFieldShouldReturnIdentifiableAction
        self.inputFieldShouldChangeCharactersAction = inputFieldShouldChangeCharactersAction
        self.inputFieldShouldChangeCharactersIdentifiableAction = inputFieldShouldChangeCharactersIdentifiableAction
    }
    
    fileprivate func didBeginEditing() {
        if isBeingUpdated { return }
        onBeginEditing(updateBinding: true)
    }
    
    fileprivate func didEndEditing() {
        if isBeingUpdated { return }
        onEndEditing(updateBinding: true)
    }
    
    fileprivate func shouldReturn(textInput: UITextInput) -> Bool {
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
            DispatchQueue.main.async {
                textInput.resignFirstResponder()
                
                self.inputFieldReturnAction()

                if let identifier = self.identifier {
                    self.inputFieldReturnIdentifiableAction(identifier)
                }
            }
        }

        return shouldReturn
    }
    
    fileprivate func shouldChange(textInput: UITextInput, charactersIn range: NSRange, replacementString string: String) -> Bool {
        if isBeingUpdated { return true }

        let text = ((textInput.text) as NSString)
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
                textInput.text = modifiedValue
                return false
            case .reject:
                return false
        }
    }
    
    fileprivate func didChange(textInput: UITextInput) {
        if isBeingUpdated { return }

        let newValue = textInput.text

        if value != newValue {
            // This is a safer place to report the actual value, as it can be modified by system silently.
            // Example: `emailAddress` type being hijacked by system when using autocomplete
            // https://github.com/lionheart/openradar-mirror/issues/18086
            value = newValue
        }
    }

    fileprivate func onBeginEditing(updateBinding: Bool) {
        inputFieldBeginEditingAction()

        if let identifier {
            inputFieldBeginEditingIdentifiableAction(identifier)

            if updateBinding {
                updateInputFieldFocusBindingIfNeeded(identifier)
            }
        }
    }

    fileprivate func onEndEditing(updateBinding: Bool) {
        inputFieldEndEditingAction()

        if let identifier {
            inputFieldEndEditingIdentifiableAction(identifier)

            if updateBinding {
                updateInputFieldFocusBindingIfNeeded(nil)
            }
        }
    }

    private func updateInputFieldFocusBindingIfNeeded(_ value: AnyHashable?) {
        valueToUpdate = [value]

        if value != inputFieldFocus?.binding.wrappedValue {
            // Update binding for SwiftUI
            inputFieldFocus?.binding.wrappedValue = value

            // The binding update is not reflected in the immediate `updateUIView` cycle
            // that follows. Needs to be dispatched and cleared.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.valueToUpdate = []
            }
        }

    }
}

// MARK: - UITextFieldDelegate
extension TextFieldCoordinator: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn(textInput: textField)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldChange(textInput: textField, charactersIn: range, replacementString: string)
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        didChange(textInput: textField)
    }
}

// MARK: - UITextViewDelegate
extension TextFieldCoordinator: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing()
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditing()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let shouldChange = shouldChange(textInput: textView, charactersIn: range, replacementString: text)
        
        let numberOfGlyphs = textView.layoutManager.numberOfGlyphs
        var numberOfLines: Int = 0
        var index: Int = 0
        var lineRange = NSRange()

        while index < numberOfGlyphs {
            textView.layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }

        return shouldChange && (numberOfLines <= textView.textContainer.maximumNumberOfLines)
    }

    public func textViewDidChange(_ textView: UITextView) {
        (textView as? InsetableTextView)?.updatePromptVisibility()
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        didChange(textInput: textView)
    }
}

// MARK: -
extension UITextInput {

    func toggleKeyboardFocus(_ focus: Bool, coordinator: TextFieldCoordinator) {
        guard self.textInputView?.superview?.window != nil else { return }

        if focus {
            TextFieldCoordinator.textFieldToBecomeResponder = self

            DispatchQueue.main.async {
                TextFieldCoordinator.debounceBecomeResponder(coordinator: coordinator)
            }
        } else {
            TextFieldCoordinator.textFieldToResignResponder = self

            DispatchQueue.main.async {
                TextFieldCoordinator.debounceResignResponder(coordinator: coordinator)
            }
        }
    }
    
    var textRange: UITextRange {
        textRange(from: beginningOfDocument, to: endOfDocument) ?? .init()
    }
    
    var text: String {
        get { 
            text(in: textRange) ?? "" 
        }
        set {
            replace(textRange, withText: newValue) 
        }
    }
    
    /// Attempt to dismiss the keyboard.
    /// Setting the @FocusState to nil in a call site has the same effect.
    func resignFirstResponder() {
        var attempts = 2
        var view: UIView? = textInputView
        
        while attempts > 0 {
            guard let superview = view?.superview else { return }
            
            if superview.resignFirstResponder() {
                return
            }
            
            view = superview
            attempts -= 1
        }
    }
}

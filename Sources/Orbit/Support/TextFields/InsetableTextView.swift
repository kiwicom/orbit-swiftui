import UIKit

/// Orbit `UITextView` wrapper with a larger touch area and a prompt.
public class InsetableTextView: UITextView {

    public var insets: UIEdgeInsets = .zero
    
    public var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }
    
    var prompt = "" {
        didSet {
            if prompt != promptLabel.text {
                promptLabel.text = prompt
                updatePromptVisibility()
            }
        }
    }
    
    var numberOfLines = 0 {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
            promptLabel.numberOfLines = numberOfLines
        }
    }
    
    let promptLabel = UILabel()
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = nil
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = numberOfLines
        
        promptLabel.numberOfLines = numberOfLines
        promptLabel.adjustsFontSizeToFitWidth = true
        promptLabel.lineBreakMode = .byWordWrapping
        promptLabel.textColor = .inkLight
        
        addSubview(promptLabel)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentInset = insets
        // Fixes iOS15 inset issues
        contentOffset = .init(x: -insets.left, y: contentOffset.y)
        let size = promptLabel.sizeThatFits(bounds.inset(by: insets).size)
        promptLabel.frame = .init(origin: .zero, size: size)
    }
    
    override public func deleteBackward() {
        if shouldDeleteBackwardAction(text ?? "") {
            super.deleteBackward()
        }
    }

    override public func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()

        // Prevent erasing the current value
        if let text {
            replace(withText: text, keepingCapacity: true)
        }

        return success
    }

    func updatePromptVisibility() {
        promptLabel.isHidden = text.isEmpty == false
    }
    
    func replace(withText text: String, keepingCapacity: Bool = false) {
        self.text?.removeAll(keepingCapacity: keepingCapacity)
        insertText(text)
    }
}

import UIKit

/// Orbit `UITextView` wrapper with a larger touch area and a prompt.
public class InsetableTextView: UITextView, NSLayoutManagerDelegate {

    public var insets: UIEdgeInsets = .zero
    
    public var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }
    
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
        contentInsetAdjustmentBehavior = .always
        layoutManager.delegate = self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentInset = insets
        // Fixes iOS15 inset issues
        contentOffset = .init(x: -insets.left, y: contentOffset.y)
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
    
    public func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        // Matches the multiline line spacing of Orbit Text.
        2.5
    }
    
    func replace(withText text: String, keepingCapacity: Bool = false) {
        self.text?.removeAll(keepingCapacity: keepingCapacity)
        insertText(text)
    }
}

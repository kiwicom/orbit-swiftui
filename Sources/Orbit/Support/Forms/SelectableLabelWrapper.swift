import SwiftUI
import UIKit

struct SelectableLabelWrapper: UIViewRepresentable {

    let text: String
    private let selectableLabel = SelectableLabel()

    init(text: String) {
        self.text = text
    }

    func makeUIView(context _: Context) -> UILabel {

        selectableLabel.text = text

        selectableLabel.setContentHuggingPriority(.required, for: .horizontal)
        selectableLabel.setContentHuggingPriority(.required, for: .vertical)

        selectableLabel.textColor = .clear
        return selectableLabel
    }

    func updateUIView(_ uiView: UILabel, context _: Context) {
        uiView.text = text
    }
}

private final class SelectableLabel: UILabel {

    /// Allows override default behaviour (copying whole text) by for example copying only part of it
    public var textToBeCopied: String?

    override public init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress)
            )
        )
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var canBecomeFirstResponder: Bool {
        true
    }

    override public func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        action == #selector(copy(_:))
    }

    // MARK: - UIResponderStandardEditActions
    override public func copy(_: Any?) {
        UIPasteboard.general.string = textToBeCopied ?? text
    }

    // MARK: - Long-press Handler
    @objc private func handleLongPress(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            self.becomeFirstResponder()
            UIMenuController.shared.showMenu(from: self, rect: self.bounds)
        }
    }
}

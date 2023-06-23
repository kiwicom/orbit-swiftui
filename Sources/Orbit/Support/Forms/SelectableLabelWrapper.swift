import SwiftUI
import UIKit

struct CopyableText: UIViewRepresentable {

    private let text: String
    private let label = CopyableLabel()

    init(_ text: String) {
        self.text = text
    }

    func makeUIView(context _: Context) -> UILabel {
        label.text = text
        label.textColor = .clear
        return label
    }

    func updateUIView(_ uiView: UILabel, context _: Context) {
        uiView.text = text
    }
}

private final class CopyableLabel: UILabel {

    /// Allows override default behaviour (copying whole text) by for example copying only part of it
    var textToBeCopied: String?

    override init(frame: CGRect) {
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

    override var canBecomeFirstResponder: Bool {
        true
    }

    override func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        action == #selector(copy(_:))
    }

    // MARK: - UIResponderStandardEditActions
    override func copy(_: Any?) {
        UIPasteboard.general.string = textToBeCopied ?? text
    }

    // MARK: - Long-press Handler
    @objc func handleLongPress(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            self.becomeFirstResponder()
            UIMenuController.shared.showMenu(from: self, rect: self.bounds)
        }
    }

    override var intrinsicContentSize: CGSize {
        // Required to fit the SwiftUI content
        .zero
    }
}

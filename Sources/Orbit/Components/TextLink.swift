import Combine
import SwiftUI

/// A  companion component to ``Text`` that only shows TextLinks, detected in html formatted content.
///
/// - Related components:
///   - ``Text``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/textlink/)
@available(iOS, deprecated: 15.0, message: "Will be replaced with a native markdown-enabled Text component")
public struct TextLink: UIViewRepresentable {

    /// An action handler for a link tapped inside the ``Text`` component.
    public typealias Action = (URL, String) -> Void

    let layoutManager: NSLayoutManager = .init()

    let content: NSAttributedString
    let size: CGSize
    let color: UIColor
    let action: Action

    public func makeUIView(context _: UIViewRepresentableContext<TextLink>) -> TextLinkView {
        TextLinkView(layoutManager: layoutManager, size: size, action: action)
    }

    public func updateUIView(_ uiView: TextLinkView, context: UIViewRepresentableContext<TextLink>) {
        uiView.update(
            content: content,
            size: size,
            lineLimit: context.environment.lineLimit ?? 0,
            color: color
        )
    }
}

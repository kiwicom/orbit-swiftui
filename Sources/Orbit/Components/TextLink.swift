import Combine
import SwiftUI

/// A  companion component to ``Text`` that only shows TextLinks, detected in html formatted content.
///
/// The component is created automatically for all `<a href>` and `<applink>` tags found in a formatted text.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/textlink/)
public struct TextLink: UIViewRepresentable {

    @Environment(\.textLinkAction) var textLinkAction
    @Environment(\.textLinkColor) var textLinkColor

    let content: NSAttributedString
    let bounds: CGSize
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: UIViewRepresentableContext<TextLink>) -> TextLinkView {
        let textLinkView = TextLinkView(layoutManager: NSLayoutManager(), size: bounds) {
            HapticsProvider.sendHapticFeedback(.light(0.5))
            textLinkAction?($0, $1)
        }
        
        let tapRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleLinkTap)
        )
        
        textLinkView.addGestureRecognizer(tapRecognizer)
        return textLinkView
    }

    public func updateUIView(_ uiView: TextLinkView, context: UIViewRepresentableContext<TextLink>) {
        uiView.update(
            content: content,
            size: bounds,
            lineLimit: context.environment.lineLimit ?? 0,
            color: textLinkColor?.uiValue ?? Color.primary.uiValue
        )
    }
    
    public class Coordinator {
        var parent: TextLink

        init(_ textLink: TextLink) {
            parent = textLink
        }
        
        /// Allows to handle link tap quicker than delayed `textView(shouldInteractWith:)`.
        @objc func handleLinkTap(_ recognizer: UITapGestureRecognizer) {
            guard let textView = recognizer.view as? UITextView else { return }
            
            let tapLocation = recognizer.location(in: recognizer.view)
            let glyphIndex = textView.layoutManager.glyphIndex(for: tapLocation, in: textView.textContainer)
            let characterIndex = textView.layoutManager.characterIndexForGlyph(at: glyphIndex)
        
            guard let attributedText = textView.attributedText else { return }
            
            let fullRange = NSRange(location: 0, length: attributedText.length)

            attributedText.enumerateAttributes(in: fullRange, options: []) { attributes, range, _ in
                if NSLocationInRange(characterIndex, range), let url = attributes[.link] as? URL {
                    let text = attributedText.attributedSubstring(from: range).string
                    parent.textLinkAction?(url, text)
                    return
                }
            }
        }
    }
}

// MARK: - Inits
extension TextLink {

    /// Creates an Orbit TextLink.
    ///
    /// The component has a size of the original text, but it only display detected links, hiding any non-link content.
    /// Use `textLink(color:)` to override the TextLink colors.
    public init(_ content: NSAttributedString, bounds: CGSize) {
        self.content = content
        self.bounds = bounds
    }
}

// MARK: - Types
public extension TextLink {

    /// An action handler for a link tapped inside the ``Text`` or ``TextLink`` component.
    typealias Action = (URL, String) -> Void

    /// Orbit TextLink color.
    enum Color: Equatable {
        case primary
        case secondary
        case status(Status)
        case custom(UIColor)

        public var value: SwiftUI.Color {
            SwiftUI.Color(uiValue)
        }

        public var uiValue: UIColor {
            switch self {
                case .primary:              return .productDark
                case .secondary:            return .inkDark
                case .status(.info):        return .blueDark
                case .status(.success):     return .greenDark
                case .status(.warning):     return .orangeDark
                case .status(.critical):    return .redDark
                case .custom(let color):    return color
            }
        }
    }
}

// MARK: - Previews
struct TextLinkPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            colors
            interactive
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TextLink(
            TagAttributedStringBuilder.all.attributedString(
                link("Text link"),
                alignment: .leading,
                fontSize: Text.Size.normal.value,
                fontWeight: .regular,
                lineSpacing: nil
            ),
            bounds: .zero
        )
        .frame(width: 100, height: 60)
        .previewDisplayName()
    }

    static var colors: some View {
        VStack(alignment: .leading, spacing: .large) {
            Text(link("Primary link"))
            Text(link("Secondary link"))
                .textLinkColor(.secondary)
            Text(link("Info link"))
                .textLinkColor(.status(.info))
            Text(link("Success link"))
                .textLinkColor(.status(.success))
            Text(link("Warning link"))
                .textLinkColor(.status(.warning))
            Text(link("Critical link"))
                .textLinkColor(.status(.critical))
        }
        .previewDisplayName()
    }

    static func link(_ content: String) -> String {
        "<a href=\"...\">\(content)</a>"
    }

    static var interactive: some View {
        StateWrapper((0, "")) { state in
            VStack(spacing: .xLarge) {
                Text("Text containing <a href=\"...\">Some TextLink</a> and <a href=\"...\">Another TextLink</a>")
                    .textLinkAction {
                        state.wrappedValue.0 += 1
                        state.wrappedValue.1 = $1
                    }
                
                ButtonLink("ButtonLink") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "ButtonLink"
                }
                
                Button("Button") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "Button"
                }
                
                Text("Tapped \(state.wrappedValue.0)x", color: .inkNormal)
                Text("Tapped \(state.wrappedValue.1)", color: .inkNormal)
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        colors
            .padding(.medium)
    }
}

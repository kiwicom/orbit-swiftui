import Combine
import SwiftUI

/// A  companion component to ``Text`` that only shows TextLinks, detected in html formatted content.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/textlink/)
@available(iOS, deprecated: 15.0, message: "Will be replaced with a native markdown-enabled Text component")
public struct TextLink: UIViewRepresentable {

    /// An action handler for a link tapped inside the ``Text`` component.
    public typealias Action = (URL, String) -> Void

    let content: NSAttributedString
    let bounds: CGSize
    let color: Color
    let action: Action
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: UIViewRepresentableContext<TextLink>) -> TextLinkView {
        let textLinkView = TextLinkView(layoutManager: NSLayoutManager(), size: bounds, action: action)
        
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
            color: color.uiValue
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
                    parent.action(url, text)
                    return
                }
            }
        }
    }
}

// MARK: - Inits
extension TextLink {

    /// Creates an Orbit TextLink layer that only contains links (ignoring any non-link content) inside specified bounds.
    public init(_ content: NSAttributedString, bounds: CGSize, color: TextLink.Color = .primary, action: @escaping TextLink.Action = {_, _ in }) {
        self.content = content
        self.bounds = bounds
        self.color = color
        self.action = action
    }
}

// MARK: - Types
extension TextLink {

    /// Orbit TextLink color.
    public enum Color: Equatable {
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
            storybook
            storybookLive
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TextLink(
            TagAttributedStringBuilder.all.attributedStringForLinks(
                link("Text link"),
                fontSize: Text.Size.normal.value,
                fontWeight: .regular,
                lineSpacing: nil,
                alignment: .leading
            ),
            bounds: .zero
        )
        .frame(width: 100, height: 60)
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .large) {
            Text(link("Primary link"), linkColor: .primary)
            Text(link("Secondary link"), linkColor: .secondary)
            Text(link("Info link"), linkColor: .status(.info))
            Text(link("Success link"), linkColor: .status(.success))
            Text(link("Warning link"), linkColor: .status(.warning))
            Text(link("Critical link"), linkColor: .status(.critical))
        }
    }

    static func link(_ content: String) -> String {
        "<a href=\"...\">\(content)</a>"
    }

    static var storybookLive: some View {
        StateWrapper(initialState: (0, "")) { state in
            VStack(spacing: .xLarge) {
                Text("Text containing <a href=\"...\">Some TextLink</a> and <a href=\"...\">Another TextLink</a>") { link, text in
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = text
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
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }
}

struct TextLinkDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        TextLinkPreviews.storybook
    }
}

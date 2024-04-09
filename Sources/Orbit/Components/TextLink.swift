import Combine
import SwiftUI

/// Orbit component that displays a one or more interactive links detected in html formatted content.
/// A counterpart of the native `SwiftUI.Link`.
///
/// A ``TextLink`` is created using the `NSAttributedString` content that includes html tags `<a href>` or `<applinkX>` and an ``TextLink/Action`` provided by ``textLinkAction(_:)`` modifier.
///
/// ```swift
/// Group {
///     // A standalone `TextLink` component
///     TextLink(NSAttributedString("<a href=\"...\">TextLink</a>"))
///     
///     // Orbit `Text` that contains a `TextLink` as an interactive layer over the text.
///     Text("Text with <ref>formatting</ref>,<br> <u>multiline</u> content and <a href=\"...\">TextLink</a>")
/// }
/// .textLinkAction { url, label in
///     // TextLink tap Action
/// }
/// ```
///
/// ### Customizing appearance
/// 
/// The `TextLink` color can be modified by ``textLinkColor(_:)`` modifier.
///
/// ```swift
/// TextLink(NSAttributedString(htmlText))
///     .textLinkColor(.blueNormal)
/// Text(htmlText)
///     .textLinkColor(.blueNormal)
/// ```
/// - Important: Prefer using the Orbit ``Text`` component that automatically includes the `TextLink` as a layer for all detected links.
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/textlink/)
public struct TextLink: UIViewRepresentable {

    @Environment(\.textLinkAction) private var textLinkAction
    @Environment(\.textLinkColor) private var textLinkColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let content: NSAttributedString
    
    private func resolvedLinkColor(in environment: EnvironmentValues) -> UIColor {
        if #available(iOS 14, *), environment.redactionReasons.isEmpty == false {
            return .clear
        }

        return textLinkColor?.value.uiColor ?? Color.primary.value.uiColor
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: UIViewRepresentableContext<TextLink>) -> TextLinkView {
        let textLinkView = TextLinkView(layoutManager: NSLayoutManager()) {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }
            
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
            lineLimit: context.environment.lineLimit ?? 0,
            color: resolvedLinkColor(in: context.environment)
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
    
    /// Creates Orbit ``TextLink`` standalone component.
    public init(_ content: NSAttributedString) {
        self.content = content
    }
}

// MARK: - Types
public extension TextLink {

    /// An action handler for links tapped inside the Orbit ``Text`` and ``TextLink`` components.
    typealias Action = (URL, String) -> Void

    /// Orbit ``TextLink`` color.
    enum Color: Equatable {
        case primary
        case secondary
        case status(Status)
        case custom(SwiftUI.Color)

        public var value: SwiftUI.Color {
            switch self {
                case .primary:              return .productDark
                case .secondary:            return .inkDark
                case .status(let status):   return status.darkColor
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
            )
        )
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
                
                Text("Tapped \(state.wrappedValue.0)x")
                Text("Tapped \(state.wrappedValue.1)")
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        colors
            .padding(.medium)
    }
}

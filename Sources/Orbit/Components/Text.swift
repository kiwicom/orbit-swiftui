import SwiftUI

/// Renders text blocks in styles to fit the purpose.
///
/// Can contain html formatted text that will be rendered as interactive ``TextLink`` layer.
///
/// - Related components:
///   - ``Heading``
///   - ``TextLink``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/text/)
/// - Important: Component has fixed vertical size.
public struct Text: View {

    let content: String
    let size: Size
    let color: Color?
    let weight: Font.Weight
    let lineSpacing: CGFloat?
    let alignment: TextAlignment
    let accentColor: UIColor
    let linkColor: TextLink.Color
    let linkAction: TextLink.Action
    let isSelectable: Bool
    let kerning: CGFloat
    let strikethrough: Bool

    public var body: some View {
        if content.isEmpty == false {
            if content.containsHtmlFormatting {
                SwiftUI.Text(attributedText)
                    .strikethrough(strikethrough, color: foregroundColor.map(SwiftUI.Color.init))
                    .kerning(kerning)
                    .multilineTextAlignment(alignment)
                    .lineSpacing(lineSpacing ?? 0)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay(selectableText)
                    .overlay(textLinks)
            } else {
                SwiftUI.Text(verbatim: content)
                    .strikethrough(strikethrough, color: foregroundColor.map(SwiftUI.Color.init))
                    .kerning(kerning)
                    .foregroundColor(foregroundColor.map(SwiftUI.Color.init))
                    .font(.orbit(size: scaledSize, weight: weight, style: size.textStyle))
                    .lineSpacing(lineSpacing ?? 0)
                    .multilineTextAlignment(alignment)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay(selectableText)
            }
        }
    }

    @ViewBuilder var textLinks: some View {
        if content.containsTextLinks {
            GeometryReader { geometry in
                TextLink(content: textLinkContent, bounds: geometry.size, color: linkColor) { url, text in
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    linkAction(url, text)
                }
                .accessibility(addTraits: .isLink)
            }
        }
    }

    @ViewBuilder var selectableText: some View {
        if isSelectable {
            GeometryReader { geometry in
                SelectableLabelWrapper(text: attributedText.string)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
            }
        }
    }

    var textLinkContent: NSAttributedString {
        TagAttributedStringBuilder.all.attributedStringForLinks(
            content,
            fontSize: size.value,
            fontWeight: weight,
            lineSpacing: lineSpacing,
            alignment: alignment
        )
    }

    var foregroundColor: UIColor? {
        color?.uiValue
    }

    var attributedText: NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content,
            fontSize: size.value,
            fontWeight: weight,
            lineSpacing: lineSpacing,
            color: foregroundColor,
            linkColor: .clear,
            accentColor: accentColor
        )
    }

    var scaledSize: CGFloat {
        #if DEBUG
        return UIFontMetrics.default.scaledValue(for: size.value)
        #else
        return size.value
        #endif
    }
}

// MARK: - Inits
public extension Text {
    
    /// Creates Orbit Text component that displays a string literal.
    ///
    /// - Parameter content: String to display. Supports html formatting tags
    /// `<strong>`, `<u>`, `<ref>`, `<a href>` and `<applink>`.
    /// - Parameter size: Font size.
    /// - Parameter color: Font color (overridable by formatting).
    /// - Parameter weight: Base font weight (overridable by formatting).
    /// - Parameter lineSpacing: Distance in points between the bottom of one line fragment and the top of the next.
    /// - Parameter alignment: Horizontal alignment.
    /// - Parameter accentColor: Color for `<ref>` formatting tag.
    /// - Parameter linkColor: Color for `<a href>` and `<applink>` formatting tag.
    /// - Parameter linkAction: Handler for any detected TextLink tap action.
    /// - Parameter isSelectable: Determines if text is copyable using long tap gesture.
    /// - Parameter kerning: Additional spacing between characters.
    /// - Parameter strikethrough: Determines if strikethrough should be applied.
    init(
        _ content: String,
        size: Size = .normal,
        color: Color? = .inkNormal,
        weight: Font.Weight = .regular,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading,
        accentColor: UIColor? = nil,
        linkColor: TextLink.Color = .primary,
        isSelectable: Bool = false,
        strikethrough: Bool = false,
        kerning: CGFloat = 0,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.content = content
        self.size = size
        self.color = color
        self.weight = weight
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.accentColor = accentColor ?? color?.uiValue ?? .inkNormal
        self.linkColor = linkColor
        self.isSelectable = isSelectable
        self.strikethrough = strikethrough
        self.kerning = kerning
        self.linkAction = linkAction
    }
}

// MARK: - Types
public extension Text {

    enum Size {
        /// 12 pts.
        case small
        /// 14 pts.
        case normal
        /// 16 pts.
        case large
        /// 18 pts.
        case xLarge
        case custom(CGFloat)

        public var value: CGFloat {
            switch self {
                case .small:                return 12
                case .normal:               return 14
                case .large:                return 16
                case .xLarge:               return 18
                case .custom(let size):     return size
            }
        }

        public var textStyle: Font.TextStyle {
            switch self {
                case .small:                return .footnote
                case .normal:               return .body
                case .large:                return .callout
                case .xLarge:
                    if #available(iOS 14.0, *) {
                        return .title3
                    } else {
                        return .callout
                    }
                case .custom:               return .body
            }
        }
        
        public var lineHeight: CGFloat {
            switch self {
                case .small:                return 16
                case .normal:               return 20
                case .large:                return 24
                case .xLarge:               return 24
                case .custom(let size):     return size * 1.31
            }
        }
        
        public var iconSize: CGFloat {
            switch self {
                case .large:                return 22
                default:                    return lineHeight
            }
        }
    }

    enum Color: Equatable {
        case inkNormal
        case inkLight
        case white
        case custom(UIColor)

        var value: SwiftUI.Color {
            SwiftUI.Color(uiValue)
        }
        
        var uiValue: UIColor {
            switch self {
                case .inkNormal:            return .inkNormal
                case .inkLight:             return .inkLight
                case .white:                return .whiteNormal
                case .custom(let color):    return color
            }
        }
    }
}

// MARK: - Constants
extension Text {
    
    // Alignment ratio for text size.
    public static var firstBaselineRatio: CGFloat { 0.26 }
}

extension TextAlignment {

    public init(_ horizontalAlignment: HorizontalAlignment) {
        switch horizontalAlignment {
            case .leading:      self = .leading
            case .center:       self = .center
            case .trailing:     self = .trailing
            default:            self = .center
        }
    }
}

// MARK: - Previews
struct TextPreviews: PreviewProvider {

    static let multilineText = "Text longer and multiline with no links"
    static let multilineFormattedText = "Text longer and <u>multiline</u> with <a href=\"...\">text link</a>"

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
            sizes
            multiline
            custom
            attributedTextSnapshots
            attributedTextInteractive
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Text("Plain text with no formatting")
            .previewDisplayName("Standalone")
    }

    @ViewBuilder static var storybook: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                standalone
                Text("Selectable text (on long tap)", isSelectable: true)
                Text("Text <u>formatted</u> <strong>and</strong> <ref>accented</ref>", accentColor: .orangeNormal)
                Text(multilineText)
                Text(multilineFormattedText)
                Text(multilineFormattedText, color: .none)
                    .foregroundColor(.blueDark)
                Text(multilineText, alignment: .trailing)
                Text(multilineFormattedText, alignment: .trailing)
                Text("Text with strikethrough and kerning", strikethrough: true, kerning: 6)
            }
            .border(Color.cloudDark)
        }
        .frame(width: 150)
        .padding(.medium)
        .previewDisplayName("Formatted")
    }

    @ViewBuilder static var sizes: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                text("Text Small", size: .small, weight: .regular)
                text("Text Normal", size: .normal, weight: .regular)
                text("Text Large", size: .large, weight: .regular)
                text("Text Extra Large", size: .xLarge, weight: .regular)
            }

            Separator()

            Group {
                text("Text Medium Small", size: .small, weight: .medium)
                text("Text Medium Normal", size: .normal, weight: .medium)
                text("Text Medium Large", size: .large, weight: .medium)
                text("Text Medium Extra Large", size: .xLarge, weight: .medium)
            }

            Separator()

            Group {
                text("Text Bold Small", size: .small, weight: .bold)
                text("Text Bold Normal", size: .normal, weight: .bold)
                text("Text Bold Large", size: .large, weight: .bold)
                text("Text Bold Extra Large", size: .xLarge, weight: .bold)
            }
        }
        .padding(.medium)
        .previewDisplayName("Sizes")
    }

    @ViewBuilder static var multiline: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                text("Text Small with a very very very very large and multine content", size: .small, weight: .regular)
                text("Text Normal with a very very very very large and multine content", size: .normal, weight: .regular)
                text("Text Large with a very very very very large and multine content", size: .large, weight: .regular)
                text("Text Extra Large with a very very very very large and multine content", size: .xLarge, weight: .regular)
            }

            Separator()

            Group {
                text("Text Medium Small with a very very very very large and multine content", size: .small, weight: .medium)
                text("Text Medium Normal with a very very very very large and multine content", size: .normal, weight: .medium)
                text("Text Medium Large with a very very very very large and multine content", size: .large, weight: .medium)
                text("Text Medium Extra Large with a very very very very large and multine content", size: .xLarge, weight: .medium)
            }

            Separator()

            Group {
                text("Text Bold Small with a very very very very large and multine content", size: .small, weight: .bold)
                text("Text Bold Normal with a very very very very large and multine content", size: .normal, weight: .bold)
                text("Text Bold Large with a very very very very large and multine content", size: .large, weight: .bold)
                text("Text Bold Extra Large with a very very very very large and multine content", size: .xLarge, weight: .bold)
            }
        }
        .padding(.medium)
        .previewDisplayName("Multiline")
    }

    static var custom: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                Text("Text custom size", size: .custom(5))
                Text("Text custom size", size: .custom(21))
                
                Text("Text <strong>formatted</strong> custom size", size: .custom(5))
                Text("Text <strong>formatted</strong> custom size", size: .custom(21))
                
                Text("Text <applink1>TextLink</applink1> custom size", size: .custom(5))
                Text("Text <applink1>TextLink</applink1> custom size", size: .custom(21))
                Separator()
            }
            
            Group {
                Text("Text Normal - Undefined color, modified to Blue", size: .normal, color: nil)
                    .foregroundColor(.blueNormal)
                    .foregroundColor(.redNormal)
                Text("Text Normal - InkLight color", size: .normal, color: .inkLight)
                    .foregroundColor(.blueNormal)
                    .foregroundColor(.redNormal)
                Text("Text Normal - Custom color", size: .normal, color: .custom(.productDark))
                    .foregroundColor(.blueNormal)
                    .foregroundColor(.redNormal)
                
                Separator()
            }

            Group {
                Text("Text Normal, M")
                    .environment(\.sizeCategory, .medium)
                Text("Text Normal, XS")
                    .environment(\.sizeCategory, .extraSmall)
                Text("Text Normal, XXXL")
                    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Custom")
    }

    static var snapshotsSizing: some View {
        VStack(spacing: .medium) {
            standalone
                .border(Color.cloudDark)
            storybook
        }
    }

    static var attributedTextInteractive: some View {
        StateWrapper(initialState: (0.7, 0.7, 0.7)) { state in
            ScrollView {
                VStack(alignment: .leading, spacing: .medium) {
                    Text(
                        """
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """,
                        accentColor: .redNormal
                    )
                    .border(Color.cloudDark)
                    .padding(.trailing, 200 * (1 - state.wrappedValue.0))

                    Slider(
                        value: Binding<Double>(get: { state.wrappedValue.0 }, set: { state.wrappedValue.0 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """,
                        size: .custom(12),
                        color: .custom(.blueLightActive),
                        weight: .bold,
                        accentColor: .blueNormal
                    )
                    .border(Color.cloudDark)
                    .padding(.leading, 200 * (1 - state.wrappedValue.1))

                    Slider(
                        value: Binding<Double>(get: { state.wrappedValue.1 }, set: { state.wrappedValue.1 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        A normal basic very very long text that contains no tags or links.
                        """
                    )
                    .border(Color.cloudDark)
                    .padding(.trailing, 200 * (1 - state.wrappedValue.2))

                    Slider(
                        value: Binding<Double>(get: { state.wrappedValue.2 }, set: { state.wrappedValue.2 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        Line limit is set to <ref>2</ref>.
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """,
                        size: .custom(22),
                        color: .inkLight,
                        weight: .bold
                    )
                    .lineLimit(2)
                    .border(Color.cloudDark)
                }
            }
            .padding()
            .previewDisplayName("Live Preview")
            .previewLayout(.sizeThatFits)
        }
    }

    static var attributedTextSnapshots: some View {
        VStack(alignment: .leading, spacing: .medium) {

            Text("An <ref>attributed</ref> text <a href=\"..\">link</a>", accentColor: .orangeNormal)
                .border(Color.cloudDarker)
                .padding()

            Text(
                """
                Custom line height set to 12pt.
                Custom line height set to 12pt.
                Custom line height set to 12pt.
                """,
                lineSpacing: Spacing.small
            )
            .padding()

            Text(
                """
                <b>Custom line height</b> set to 12pt.
                <b>Custom line height</b> set to 12pt.
                <b>Custom line height</b> set to 12pt.
                """,
                lineSpacing: Spacing.small
            )
            .padding()

            Button("An <ref><u>attributed</u></ref> button")
                .padding(.horizontal)

            ButtonLink("An <ref>attributed</ref> <u>button</u> <applink1>link</applink1>")
                .padding(.horizontal)

            Card("Attributed alert inside Card", action: .buttonLink("Edit")) {
                Alert(
                    "Alert",
                    description: "<strong>Strong</strong> description with <a href=\"https://www.apple.com\">link</a>",
                    icon: .alert,
                    buttons: .primary("<strong>OK</strong> then, why <u>not</u>"),
                    status: .warning
                )
            }

            Card("Attributed text inside Card", action: .buttonLink("Edit")) {
                Text(
                    """
                    An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                    HTML <a href="https://www.apple.com">links</a> with \
                    <u>underline</u> and <strong>strong</strong> support.
                    """,
                    accentColor: .orangeNormal
                )

                HStack {
                    Badge("<strong>Strong</strong> badge <u>label</u>", icon: .accommodation)
                    Badge("<strong>Strong</strong> badge <u>label</u>", style: .status(.success, inverted: true))
                    Spacer(minLength: 0)
                }
                BadgeList("<strong>Strong</strong> badge <u>label</u>", icon: .accommodation, style: .status(.success))
            }
        }
        .padding(.vertical)
        .background(Color.cloudLight)
        .previewDisplayName("Attributed Text")
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static func text(_ content: String, size: Text.Size, weight: Font.Weight) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text(content, size: size, weight: weight)
            Spacer()
            Text("\(Int(size.value))/\(Int(size.lineHeight))", color: .inkLight, weight: .medium)
        }
    }
}

import SwiftUI

/// Renders text blocks in styles to fit the purpose.
///
/// Can contain html formatted text that will be rendered as interactive ``TextLink`` layer.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/text/)
/// - Important: Component has fixed vertical size.
public struct Text: View {

    @Environment(\.sizeCategory) var sizeCategory

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
            text(sizeCategory: sizeCategory)
                .lineSpacing(lineSpacing ?? 0)
                .multilineTextAlignment(alignment)
                .fixedSize(horizontal: false, vertical: true)
                .overlay(selectableText)
                .accessibility(removeTraits: showTextLinks ? .isStaticText : [])
                .accessibility(hidden: showTextLinks)
                .overlay(textLinks)
        }
    }

    @ViewBuilder var textLinks: some View {
        if showTextLinks {
            GeometryReader { geometry in
                TextLink(content: textLinkContent, bounds: geometry.size, color: linkColor) { url, text in
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    linkAction(url, text)
                }
                .accessibility(addTraits: .isLink)
                .accessibility(label: .init(content))
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

    func text(sizeCategory: ContentSizeCategory) -> SwiftUI.Text {
        if content.containsHtmlFormatting {
            return textContent {
                SwiftUI.Text(attributedText)
            }
        } else {
            return textContent {
                plainTextContent {
                    SwiftUI.Text(verbatim: content)
                }
            }
            .orbitFont(
                size: size.value,
                weight: weight,
                style: size.textStyle,
                sizeCategory: sizeCategory
            )
        }
    }

    func textContent(@ViewBuilder content: () -> SwiftUI.Text) -> SwiftUI.Text {
        content()
            .strikethrough(strikethrough, color: foregroundColor.map(SwiftUI.Color.init))
            .kerning(kerning)
    }

    func plainTextContent(@ViewBuilder content: () -> SwiftUI.Text) -> SwiftUI.Text {
        if let foregroundColor = foregroundColor {
            return content()
                .foregroundColor(SwiftUI.Color(foregroundColor))
        } else {
            return content()
        }
    }

    var showTextLinks: Bool {
        content.containsHtmlFormatting && content.containsTextLinks
    }

    var textLinkContent: NSAttributedString {
        TagAttributedStringBuilder.all.attributedStringForLinks(
            content,
            fontSize: attributedTextScaledSize,
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
            fontSize: attributedTextScaledSize,
            fontWeight: weight,
            lineSpacing: lineSpacing,
            color: foregroundColor,
            linkColor: .clear,
            accentColor: accentColor
        )
    }

    var attributedTextScaledSize: CGFloat {
        size.value * sizeCategory.ratio
    }
}

// MARK: - Inits
public extension Text {
    
    /// Creates Orbit Text component that displays a string literal.
    ///
    /// - Parameters:
    ///   - content: String to display. Supports html formatting tags `<strong>`, `<u>`, `<ref>`, `<a href>` and `<applink>`.
    ///   - size: Font size.
    ///   - color: Font color. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    ///   - weight: Base font weight (overridable by formatting).
    ///   - lineSpacing: Distance in points between the bottom of one line fragment and the top of the next.
    ///   - alignment: Horizontal multi-line alignment.
    ///   - accentColor: Color for `<ref>` formatting tag.
    ///   - linkColor: Color for `<a href>` and `<applink>` formatting tag.
    ///   - linkAction: Handler for any detected TextLink tap action.
    ///   - isSelectable: Determines if text is copyable using long tap gesture.
    ///   - kerning: Additional spacing between characters.
    ///   - strikethrough: Determines if strikethrough should be applied.
    init(
        _ content: String,
        size: Size = .normal,
        color: Color? = .inkDark,
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
        self.accentColor = accentColor ?? color?.uiValue ?? .inkDark
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
        case inkDark
        case inkNormal
        case white
        case custom(UIColor)

        public var value: SwiftUI.Color {
            SwiftUI.Color(uiValue)
        }
        
        public var uiValue: UIColor {
            switch self {
                case .inkDark:              return .inkDark
                case .inkNormal:            return .inkNormal
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

// MARK: - TextRepresentable
extension Text: TextRepresentable {

    public func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        if content.isEmpty { return nil }

        return text(sizeCategory: sizeCategory)
    }
}

// MARK: - Previews
struct TextPreviews: PreviewProvider {

    static let multilineText = "Text with multiline content \n with no formatting or text links"
    static let multilineFormattedText = "Text with <ref>formatting</ref>,<br> <u>multiline</u> content <br> and <a href=\"...\">text link</a>"

    static var previews: some View {
        PreviewWrapper {
            standalone
            formatting
            sizes
            multiline
            custom
            attributedText
            interactive
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Text("Plain text with no formatting")
            .previewDisplayName()
    }

    @ViewBuilder static var formatting: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                Text("Plain text with no formatting")
                Text("Selectable text (on long tap)", isSelectable: true)
                Text("Text <u>formatted</u> <strong>and</strong> <ref>accented</ref>", accentColor: .orangeNormal)
                Text("Text with strikethrough and kerning", strikethrough: true, kerning: 6)
            }
            .border(Color.cloudDark, width: .hairline)

            Text(multilineText, color: .custom(.greenDark), alignment: .trailing)
                .background(Color.greenLight)
            Text(multilineText, color: nil, alignment: .trailing)
                .foregroundColor(.blueDark)
                .background(Color.blueLight)
            Text(multilineFormattedText, color: .custom(.greenDark), alignment: .trailing, accentColor: .orangeDark)
                .background(Color.greenLight)
            Text(multilineFormattedText, color: nil, alignment: .trailing, accentColor: .orangeDark)
                .foregroundColor(.blueDark)
                .background(Color.blueLight)
        }
        .previewDisplayName()
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
        .previewDisplayName()
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
        .previewDisplayName()
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
                Text("Text Normal - InkNormal color", size: .normal, color: .inkNormal)
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
        .previewDisplayName()
    }

    static var snapshotsSizing: some View {
        VStack(spacing: .medium) {
            standalone
                .border(Color.cloudDark, width: .hairline)
            formatting
        }
    }

    static var interactive: some View {
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
                    .border(Color.cloudDark, width: .hairline)
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
                    .border(Color.cloudNormal)
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
                    .border(Color.cloudNormal)
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
                        color: .inkNormal,
                        weight: .bold
                    )
                    .lineLimit(2)
                    .border(Color.cloudNormal)
                }
            }
            .previewDisplayName()
        }
    }

    static var attributedText: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Text("An <ref>attributed</ref> text <a href=\"..\">link</a>", accentColor: .orangeNormal)
                .border(Color.cloudDark)

            Text(
                """
                Custom line height set to 12pt.
                Custom line height set to 12pt.
                Custom line height set to 12pt.
                """,
                lineSpacing: .small
            )

            Text(
                """
                <b>Custom line height</b> set to 12pt.
                <b>Custom line height</b> set to 12pt.
                <b>Custom line height</b> set to 12pt.
                """,
                lineSpacing: .small
            )
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        formatting
            .padding(.medium)
    }

    @ViewBuilder static func text(_ content: String, size: Text.Size, weight: Font.Weight) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text(content, size: size, weight: weight)
            Spacer()
            Text("\(Int(size.value))/\(Int(size.lineHeight))", color: .inkNormal, weight: .medium)
        }
    }
}

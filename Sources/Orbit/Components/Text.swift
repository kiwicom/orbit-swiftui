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
                .overlay(selectableText)
                .overlay(textLinks)
                .padding(.vertical, size.linePadding * sizeCategory.ratio)
                .frame(minHeight: size.lineHeight * sizeCategory.ratio)
                .fixedSize(horizontal: false, vertical: true)
                .accessibility(removeTraits: showTextLinks ? .isStaticText : [])
                .accessibility(hidden: showTextLinks)
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
                SelectableLabelWrapper(text: attributedTextWithoutTextLinks.string)
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
                SwiftUI.Text(attributedTextWithoutTextLinks)
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
            kerning: kerning,
            alignment: alignment
        )
    }

    var foregroundColor: UIColor? {
        color?.uiValue
    }

    var attributedTextWithoutTextLinks: NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content,
            fontSize: attributedTextScaledSize,
            fontWeight: weight,
            lineSpacing: lineSpacing,
            kerning: kerning,
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

    enum Size: Equatable {
        /// 13 pts.
        case small
        /// 15 pts.
        case normal
        /// 16 pts.
        case large
        /// 18 pts.
        case xLarge
        /// Custom text size.
        case custom(CGFloat)

        /// Font size.
        public var value: CGFloat {
            switch self {
                case .small:                return 13
                case .normal:               return 15
                case .large:                return 16
                case .xLarge:               return 18
                case .custom(let size):     return size
            }
        }
        
        public var lineHeight: CGFloat {
            switch self {
                case .small:                return 16
                case .normal:               return 20
                case .large:                return 24
                case .xLarge:               return 24
                case .custom(let size):     return size * Font.fontSizeToLineHeightRatio
            }
        }

        /// Text height rounded to pixels.
        public var height: CGFloat {
            round(value * Font.fontSizeToHeightRatio * 3) / 3
        }

        /// Vertical padding needed to match line height.
        public var linePadding: CGFloat {
            (lineHeight - height) / 2
        }

        /// Icon size matching text line height.
        public var iconSize: Icon.Size {
            .custom(lineHeight)
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
            sizes
            formatting
            lineHeight
            lineSpacing
            interactive
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Text("Plain text with no formatting")
            Text("") // Results in EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizes: some View {
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
        .previewDisplayName()
    }

    static var formatting: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                Text("Selectable text (on long tap)", isSelectable: true)
                Text("Text with no formatting")
                Text("Text <u>formatted</u> <strong>and</strong> <ref>accented</ref>", accentColor: .orangeNormal)
                Text("<applink1>Text</applink1> <u>formatted</u> <strong>and</strong> <ref>accented</ref>", accentColor: .orangeNormal)

                Text("Text with kerning and strikethrough", lineSpacing: 10, alignment: .trailing, strikethrough: true, kerning: 6)
                Text(
                    "Text <u>with kerning</u> <strong>and</strong> <ref>strikethrough</ref>",
                    lineSpacing: 10,
                    alignment: .trailing,
                    strikethrough: true,
                    kerning: 6
                )
                Text(
                    "<applink1>Text</applink1> <u>with kerning</u> <strong>and</strong> <applink2>strikethrough</applink2>",
                    lineSpacing: 10,
                    alignment: .trailing,
                    strikethrough: true,
                    kerning: 6
                )
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
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineHeight: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                textLineHeight(size: .custom(8), formatted: false)
                textLineHeight(size: .small, formatted: false)
                textLineHeight(size: .normal, formatted: false)
                textLineHeight(size: .large, formatted: false)
                textLineHeight(size: .xLarge, formatted: false)
            }

            VStack(alignment: .trailing, spacing: .xxxSmall) {
                textLineHeight(size: .custom(8), formatted: true)
                textLineHeight(size: .small, formatted: true)
                textLineHeight(size: .normal, formatted: true)
                textLineHeight(size: .large, formatted: true)
                textLineHeight(size: .xLarge, formatted: true)
            }

            HStack(alignment: .top) {
                Group {
                    Text("Text", size: .large)
                    Text("Text\n multiline", size: .large)
                }
                .background(Color.redLightHover)
                .overlay(
                    Separator(color: .greenNormal, thickness: .hairline).offset(y: 6),
                    alignment: .top
                )
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineSpacing: some View {
        VStack(alignment: .leading, spacing: .medium) {
            HStack(alignment: .top, spacing: .large) {
                Text(
                    """
                    Custom line spacing
                    Custom line spacing
                    Custom line spacing
                    """,
                    lineSpacing: .large
                )

                Text(
                    """
                    <b>Custom </b> line <applink1>spacing</applink1>
                    <b>Custom </b> line <applink1>spacing</applink1>
                    <b>Custom </b> line <applink1>spacing</applink1>
                    """,
                    lineSpacing: .large
                )
            }
        }
        .padding(.medium)
        .previewDisplayName()
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
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func textLineHeight(size: Text.Size, formatted: Bool) -> some View {
        HStack(spacing: .xxSmall) {
            Text(
                "Size \(formatted ? "<applink1>" : "")\(size)\(formatted ? "</applink1>" : "") \(size.value.formatted) / \(size.lineHeight.formatted)",
                size: size
            )
            .background(Color.redLightHover.frame(height: size.height))
            .background(Color.redLightActive)
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)

            Text(
                "(\(size.height.formatted) + 2 x \(size.linePadding.formatted))",
                size: .custom(8),
                color: .custom(.redNormal)
            )
            .environment(\.sizeCategory, .large)
        }
        .measured()
    }

    static func text(_ content: String, size: Text.Size, weight: Font.Weight) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text(content, size: size, weight: weight)
            Spacer()
            Text("\(Int(size.value))/\(Int(size.lineHeight))", color: .inkNormal, weight: .medium)
        }
    }
}

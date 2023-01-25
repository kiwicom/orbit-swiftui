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
    let isSelectable: Bool
    let strikethrough: Bool
    let kerning: CGFloat
    let linkAction: TextLink.Action

    public var body: some View {
        if content.isEmpty == false {
            text(sizeCategory: sizeCategory)
                .lineSpacing(lineSpacingAdjusted)
                .multilineTextAlignment(alignment)
                .overlay(selectableText)
                // If the text contains links, the TextLink overlay takes accessibility priority
                .accessibility(hidden: content.containsTextLinks)
                .overlay(textLinks)
                .padding(.vertical, lineHeightPadding)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder var textLinks: some View {
        if content.containsTextLinks {
            GeometryReader { geometry in
                // TextLink has embedded accessibility and exposes full text including separate link elements
                TextLink(content: textWithOnlyTextLinksVisible, bounds: geometry.size, color: linkColor) { url, text in
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    linkAction(url, text)
                }
            }
        }
    }

    @ViewBuilder var selectableText: some View {
        if isSelectable {
            GeometryReader { geometry in
                SelectableLabelWrapper(text: textWithTransparentTextLinks.string)
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
                SwiftUI.Text(textWithTransparentTextLinks)
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

    var textWithOnlyTextLinksVisible: NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content,
            alignment: alignment,
            fontSize: scaledSize,
            fontWeight: weight,
            lineSpacing: lineSpacingAdjusted,
            kerning: kerning,
            color: .clear,
            accentColor: .clear
        )
    }

    var textWithTransparentTextLinks: NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content,
            alignment: alignment,
            fontSize: scaledSize,
            fontWeight: weight,
            lineSpacing: lineSpacingAdjusted,
            kerning: kerning,
            color: foregroundColor,
            linkColor: .clear,
            accentColor: accentColor
        )
    }
    
    var foregroundColor: UIColor? {
        color?.uiValue
    }

    var scaledSize: CGFloat {
        size.value * sizeCategory.ratio
    }

    var lineSpacingAdjusted: CGFloat {
        (designatedLineHeight - originalLineHeight) + (lineSpacing ?? 0)
    }

    var lineHeightPadding: CGFloat {
        (designatedLineHeight - originalLineHeight) / 2
    }

    var originalLineHeight: CGFloat {
        UIFont.lineHeight(size: scaledSize)
    }

    var designatedLineHeight: CGFloat {
        size.lineHeight * sizeCategory.ratio
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
        case custom(CGFloat, lineHeight: CGFloat? = nil)

        /// Font size.
        public var value: CGFloat {
            switch self {
                case .small:                        return 13
                case .normal:                       return 15
                case .large:                        return 16
                case .xLarge:                       return 18
                case .custom(let size, _):          return size
            }
        }
        
        public var lineHeight: CGFloat {
            switch self {
                case .small:                        return 16
                case .normal:                       return 20
                case .large:                        return 24
                case .xLarge:                       return 24
                case .custom(_, let lineHeight?):   return lineHeight
                case .custom(let size, nil):        return size * Font.fontSizeToLineHeightRatio
            }
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
                LineHeight(size: .custom(8), formatted: false)
                LineHeight(size: .small, formatted: false)
                LineHeight(size: .normal, formatted: false)
                LineHeight(size: .large, formatted: false)
                LineHeight(size: .xLarge, formatted: false)
            }
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                LineHeight(size: .custom(8), formatted: true)
                LineHeight(size: .small, formatted: true)
                LineHeight(size: .normal, formatted: true)
                LineHeight(size: .large, formatted: true)
                LineHeight(size: .xLarge, formatted: true)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineSpacing: some View {
        HStack(alignment: .top, spacing: .xxxSmall) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                Group {
                    Text("Text single line", size: .large, lineSpacing: .xxxSmall)
                        .background(Color.redLightHover)
                    Text("Text <applink1>single</applink1> line", size: .large, lineSpacing: .xxxSmall)
                        .background(Color.redLightHover.opacity(0.7))
                    Text("Text <strong>single</strong> line", size: .large, lineSpacing: .xxxSmall)
                        .background(Color.redLightHover.opacity(0.4))
                }
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            }

            Group {
                Text("Multliline\nwith\n<strong>formatting</strong>", size: .large, lineSpacing: .xxxSmall)
                Text("Multliline\nwith\n<applink1>links</applink1>", size: .large, lineSpacing: .xxxSmall)
            }
            .background(Color.redLightHover.opacity(0.7))
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var interactive: some View {
        StateWrapper((0.7, 0.7, 0.7)) { state in
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

    struct LineHeight: View {

        @Environment(\.sizeCategory) var sizeCategory
        let size: Text.Size
        let formatted: Bool

        var body: some View {
            HStack(spacing: .xxSmall) {
                Text(
                    "\(sizeText) \(formatted ? "<applink1>" : "")\(size)\(formatted ? "</applink1>" : "")",
                    size: size,
                    accentColor: .blueDark
                )
                .fixedSize()
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)

                Text("\(size.value.formatted) / \(size.lineHeight.formatted)", size: .custom(6))
                    .environment(\.sizeCategory, .large)
            }
            .padding(.trailing, .xxSmall)
            .border(Color.redNormal, width: .hairline)
            .measured()
            .padding(.trailing, 40 * sizeCategory.controlRatio)
            .overlay(
                SwiftUI.Text("T")
                    .orbitFont(size: size.value, sizeCategory: sizeCategory)
                    .border(Color.redNormal, width: .hairline)
                    .measured()
                ,
                alignment: .trailing
            )
        }

        var sizeText: String {
            formatted
                ? "<ref>Orbit</ref>"
                : "Orbit"
        }
    }

    static func text(_ content: String, size: Text.Size, weight: Font.Weight) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text(content, size: size, weight: weight)
            Spacer()
            Text("\(Int(size.value))/\(Int(size.lineHeight))", color: .inkNormal, weight: .medium)
        }
    }
}

import SwiftUI

/// Renders text blocks in styles to fit the purpose.
///
/// Can contain html formatted text that will be rendered as interactive ``TextLink`` layer.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/text/)
/// - Important: Component has fixed vertical size.
public struct Text: View, FormattedTextBuildable {

    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    @Environment(\.lineSpacing) private var lineSpacing
    @Environment(\.textAccentColor) private var textAccentColor
    @Environment(\.sizeCategory) private var sizeCategory

    private let content: String
    private let size: Size
    private let isSelectable: Bool

    // Builder properties
    var baselineOffset: CGFloat?
    var fontWeight: Font.Weight?
    var foregroundColor: Color?
    var strikethrough: Bool?
    var kerning: CGFloat?
    var accentColor: Color?
    var isBold: Bool?
    var isItalic: Bool?
    var isUnderline: Bool?
    var isMonospacedDigit: Bool?

    // The Orbit Text consists of up to 3 layers:
    //
    // 1) SwiftUI.Text base layer, either:
    //      - SwiftUI.Text(verbatim:)           (when text is a plain text only)
    //      - SwiftUI.Text(attributedString:)   (when text contains any Orbit html formatting)
    // 2) TextLink-only overlay                 (when text contains any TextLink; limited native modifier support)
    // 3) Long-tap-to-copy gesture overlay      (when isSelectable == true)

    public var body: some View {
        if content.isEmpty == false {
            text(sizeCategory: sizeCategory, textAccentColor: textAccentColor)
                .lineSpacing(lineSpacingAdjusted)
                .overlay(selectableLabelWrapper)
                // If the text contains links, the TextLink overlay takes accessibility priority
                .accessibility(hidden: content.containsTextLinks)
                .overlay(textLinks)
                .padding(.vertical, lineHeightPadding)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder var textLinks: some View {
        if content.containsTextLinks {
            TextLink(textLinkAttributedString)
        }
    }

    @ViewBuilder var selectableLabelWrapper: some View {
        if isSelectable {
            SelectableLabelWrapper(
                attributedString().string
            )
        }
    }

    func foregroundColorWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let foregroundColor {
            return text
                .foregroundColor(foregroundColor)
        } else {
            return text
        }
    }

    func boldWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if #available(iOS 16.0, *), let isBold {
            return text
                .bold(isBold)
        }
        else if let isBold, isBold {
            return text
                .bold()
        } else {
            return text
        }
    }

    func italicWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if #available(iOS 16.0, *), let isItalic {
            return text
                .italic(isItalic)
        }
        else if let isItalic, isItalic {
            return text
                .italic()
        } else {
            return text
        }
    }

    func strikethroughWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let strikethrough {
            return text
                .strikethrough(strikethrough)
        } else {
            return text
        }
    }

    func underlineWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let isUnderline {
            return text
                .underline(isUnderline)
        } else {
            return text
        }
    }

    func monospacedDigitWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if #available(iOS 15.0, *), let isMonospacedDigit, isMonospacedDigit {
            return text
                .monospacedDigit()
        } else {
            return text
        }
    }

    func kerningWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let kerning {
            return text
                .kerning(kerning)
        } else {
            return text
        }
    }

    func baselineOffsetWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let baselineOffset {
            return text
                .baselineOffset(baselineOffset)
        } else {
            return text
        }
    }

    func fontWeightWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let fontWeight {
            return text
                .fontWeight(fontWeight)
        } else {
            return text
        }
    }

    func modifierWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        // Stacks all optional modifier overrides
        // except those that are not relevant to mixed html formatted text
        monospacedDigitWrapper(
            underlineWrapper(
                baselineOffsetWrapper(
                    strikethroughWrapper(
                        kerningWrapper(
                            italicWrapper(
                                // fontWeight and bold are omitted as they would override the mixed AttributedString
                                text
                            )
                        )
                    )
                )
            )
        )
    }

    func text(sizeCategory: ContentSizeCategory, textAccentColor: Color?, isConcatenated: Bool = false) -> SwiftUI.Text {
        if content.containsHtmlFormatting {
            return modifierWrapper(
                SwiftUI.Text(
                    attributedString(
                        textAccentColor: textAccentColor,
                        isConcatenated: isConcatenated,
                        sizeCategory: sizeCategory
                    )
                )
            )
        } else {
            return modifierWrapper(
                fontWeightWrapper(
                    boldWrapper(
                        foregroundColorWrapper(
                            SwiftUI.Text(verbatim: content)
                        )
                    )
                )
            )
            .orbitFont(
                size: size.value,
                weight: resolvedFontWeight ?? .regular,
                sizeCategory: sizeCategory
            )
        }
    }

    var textLinkAttributedString: NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content,
            alignment: multilineTextAlignment,
            fontSize: scaledSize,
            fontWeight: resolvedFontWeight,
            lineSpacing: lineSpacingAdjusted,
            kerning: kerning,
            strikethrough: strikethrough ?? false,
            color: .clear,
            accentColor: .clear
        )
    }

    func attributedString(
        textAccentColor: Color? = nil,
        isConcatenated: Bool = false,
        sizeCategory: ContentSizeCategory = .large
    ) -> NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content,
            alignment: multilineTextAlignment,
            fontSize: size.value * sizeCategory.ratio,
            fontWeight: resolvedFontWeight,
            lineSpacing: lineSpacingAdjusted,
            kerning: kerning,
            color: foregroundColor?.uiColor,
            linkColor: isConcatenated ? nil : .clear,
            accentColor: (accentColor ?? textAccentColor ?? foregroundColor ?? .inkDark).uiColor
        )
    }

    var resolvedFontWeight: Font.Weight? {
        isBold == true ? .bold : fontWeight
    }

    var scaledSize: CGFloat {
        size.value * sizeCategory.ratio
    }

    var lineSpacingAdjusted: CGFloat {
        (designatedLineHeight - originalLineHeight) + lineSpacing
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
    /// Modifiers like `textAccentColor()` or `fontWeight()` can be used to further adjust the formatting.
    /// To specify the formatting and behaviour for `TextLink`s found in the text, use `textLinkAction()` and
    /// `textLinkColor()` modifiers.
    ///
    /// - Parameters:
    ///   - content: String to display. Supports html formatting tags `<strong>`, `<u>`, `<ref>`, `<a href>` and `<applink>`.
    ///   - size: Font size.
    ///   - isSelectable: Determines if text is copyable using long tap gesture.
    ///
    /// - Important: The text concatenation does not support interactive TextLinks. It also does not fully support some global SwiftUI native text formatting view modifiers.
    /// For proper rendering of TextLinks, any required text formatting modifiers must be also called on the Text directly.
    init(
        _ content: String,
        size: Size = .normal,
        isSelectable: Bool = false
    ) {
        self.content = content
        self.size = size
        self.isSelectable = isSelectable

        // Set a default color to use in case it is not provided by a call site
        self.foregroundColor = .inkDark
    }
}

// MARK: - Types
public extension Text {

    /// Orbit text size.
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

    public func swiftUIText(sizeCategory: ContentSizeCategory, textAccentColor: Color?) -> SwiftUI.Text? {
        if content.isEmpty { return nil }

        return text(sizeCategory: sizeCategory, textAccentColor: textAccentColor, isConcatenated: true)
    }
}

// MARK: - Equatable
extension Text: Equatable {

    public static func == (lhs: Text, rhs: Text) -> Bool {
        lhs.content == rhs.content
    }
}

// MARK: - Previews
struct TextPreviews: PreviewProvider {

    static let multilineText = "Text with multiline content \n with no formatting or text links"
    static let multilineFormattedText = "Text with <ref>formatting</ref>,<br> <u>multiline</u> content <br> and <a href=\"...\">text link</a>"

    static let plainText = "Text"
    static let markdownText = "Text **str** *ita*"
    static let htmlText = "Text <strong>str</strong> <u>und</u> <ref>acc</ref> <applink1>lnk</applink1>"
    static let plusText = " + "

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizes
            multilineFormatting
            formatting
            monospaced
            lineHeight
            lineSpacing
            interactive
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var standalone: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            Text("Multiline text\nplain with with no formatting")
            Text("Multiline text\n<strong>selectable</strong> (with long tap gesture)", isSelectable: true)

            Text(
"""
Multiline text <u>underlined</u>, <strong>strong</strong>, <ref>accented</ref>,
<strong><u>underlined strong</u></strong>, <ref><u>underlined accented</u></ref>
"""
            )

            Text("""
Multiline <applink1>text</applink1> <u>underlined</u>, <strong>strong</strong>, <ref>accented</ref>,
<strong><u>underlined strong</u></strong>, <ref><u>underlined accented</u></ref>,
<strong><applink1>TextLink strong</applink1></strong>
"""
            )
            .textAccentColor(.orangeNormal)

            Text("") // Results in EmptyView
        }
        .textAccentColor(.blueNormal)
        .multilineTextAlignment(.trailing)
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

    static var multilineFormatting: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                Text("Selectable text (on long tap)", isSelectable: true)
                Text("Text with no formatting")
                Text("Text <u>formatted</u> <strong>and</strong> <ref>accented</ref>")
                    .textAccentColor(.orangeNormal)
                Text("<applink1>Text</applink1> <u>formatted</u> <strong>and</strong> <ref>accented</ref>")
                    .textAccentColor(.orangeNormal)

                if #available(iOS 16.0, *) {
                    Group {
                        Text("Text with kerning and strikethrough")
                        Text("Text <u>with kerning</u> <strong>and</strong> <ref>strikethrough</ref>")
                        Text(
                            "<applink1>Text</applink1> <u>with kerning</u> <strong>and</strong> <strong><applink2>strikethrough</applink2></strong>"
                        )
                        .kerning(6)
                        .strikethrough()
                    }
                    .textAccentColor(.orangeNormal)
                    .lineSpacing(10)
                    .kerning(6)
                    .strikethrough()
                }
            }
            .border(.cloudDark, width: .hairline)

            Text(multilineText)
                .foregroundColor(.greenDark)
                .background(Color.greenLight)
            Text(multilineText)
                .foregroundColor(nil)
                .foregroundColor(.blueDark)
                .background(Color.blueLight)
            Text(multilineFormattedText)
                .foregroundColor(.greenDark)
                .textAccentColor(.orangeDark)
                .background(Color.greenLight)
            Text(multilineFormattedText)
                .foregroundColor(nil)
                .textAccentColor(.orangeDark)
                .foregroundColor(.blueDark)
                .background(Color.blueLight)

            // This text may reveal issues between iOS TextLink word wrapping
            Text(
                "By continuing, you accept the <applink1>Terms Of Use</applink1> and <applink2>Privacy Policy</applink2>.",
                size: .small
            )
            .foregroundColor(.inkNormal)
            .textLinkColor(.secondary)
            .multilineTextAlignment(.leading)
        }
        .multilineTextAlignment(.trailing)
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var formatting: some View {
        TextFormattingPreviews.FormattingTable()
    }

    static var monospaced: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    Text("1111111111")
                    Text("8888888888")
                    Text("1111111111")
                        .monospacedDigit()
                    Text("8888888888")
                        .monospacedDigit()
                }
                .border(.cloudNormal, width: .hairline)
            }
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
                    Text("Text single line", size: .large)
                        .background(Color.redLightHover)
                    Text("Text <applink1>single</applink1> line", size: .large)
                        .background(Color.redLightHover.opacity(0.7))
                    Text("Text <strong>single</strong> line", size: .large)
                        .background(Color.redLightHover.opacity(0.4))
                }
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            }

            Group {
                Text("Multliline\nwith\n<strong>formatting</strong>", size: .large)
                Text("Multliline\nwith\n<applink1>links</applink1>", size: .large)
            }
            .lineSpacing(.xxxSmall)
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
                        """
                    )
                    .textAccentColor(.redNormal)
                    .border(.cloudDark, width: .hairline)
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
                        size: .custom(12)
                    )
                    .foregroundColor(.blueLightActive)
                    .bold()
                    .textAccentColor(.blueNormal)
                    .border(.cloudNormal)
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
                    .border(.cloudNormal)
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
                        size: .custom(22)
                    )
                    .foregroundColor(.inkNormal)
                    .bold()
                    .lineLimit(2)
                    .border(.cloudNormal)
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
                    size: size
                )
                .textAccentColor(Status.info.darkColor)
                .fixedSize()
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)

                Text("\(size.value.formatted) / \(size.lineHeight.formatted)", size: .custom(6))
                    .environment(\.sizeCategory, .large)
            }
            .padding(.trailing, .xxSmall)
            .border(.redNormal, width: .hairline)
            .measured()
            .padding(.trailing, 40 * sizeCategory.controlRatio)
            .overlay(
                SwiftUI.Text("T")
                    .orbitFont(size: size.value, sizeCategory: sizeCategory)
                    .border(.redNormal, width: .hairline)
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
            Text(content, size: size)
                .fontWeight(weight)
            Spacer()
            Text("\(Int(size.value))/\(Int(size.lineHeight))")
                .foregroundColor(.inkNormal)
                .fontWeight(.medium)
        }
    }
}

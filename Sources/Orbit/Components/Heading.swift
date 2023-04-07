import SwiftUI

/// Shows the content hierarchy and improves the reading experience. Also known as Title.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/heading/)
public struct Heading: View, FormattedTextBuildable {

    @Environment(\.sizeCategory) var sizeCategory

    let content: String
    let style: Style
    let isSelectable: Bool

    // Builder properties
    var baselineOffset: CGFloat?
    var fontWeight: Font.Weight?
    var foregroundColor: Color?
    var strikethrough: Bool?
    var kerning: CGFloat?
    var accentColor: Color?
    var isBold: Bool?
    var isItalic: Bool?
    var isMonospacedDigit: Bool?
    var isUnderline: Bool?

    public var body: some View {
        textContent
            .accessibility(addTraits: .isHeader)
    }

    @ViewBuilder var textContent: Text {
        Text(
            content,
            size: .custom(style.size, lineHeight: style.lineHeight),
            isSelectable: isSelectable
        )
        .fontWeight(fontWeight)
        .textAccentColor(accentColor)
        .baselineOffset(baselineOffset)
        .bold(isBold)
        .italic(isItalic)
        .kerning(kerning)
        .monospacedDigit(isMonospacedDigit)
        .strikethrough(strikethrough)
        .underline(isUnderline)
        .foregroundColor(foregroundColor)
    }

    func text(sizeCategory: ContentSizeCategory, textAccentColor: Color?) -> SwiftUI.Text {
        textContent
            .text(sizeCategory: sizeCategory, textAccentColor: textAccentColor)
    }
}

// MARK: - Inits
public extension Heading {

    /// Creates Orbit Heading component.
    ///
    /// Modifiers like `textAccentColor()` or `italic()` can be used to further adjust the formatting.
    /// To specify the formatting and behaviour for `TextLink`s found in the text, use `textLinkAction()` and
    /// `textLinkColor()` modifiers.
    /// 
    /// - Parameters:
    ///   - content: String to display. Supports html formatting tags `<strong>`, `<u>`, `<ref>`, `<a href>` and `<applink>`.
    ///   - style: Heading style.
    ///   - isSelectable: Determines if text is copyable using long tap gesture.
    init(
        _ content: String,
        style: Style,
        isSelectable: Bool = false
    ) {
        self.content = content
        self.style = style
        self.isSelectable = isSelectable

        // Set a default color to use in case it is not provided by a call site
        self.foregroundColor = .inkDark
        self.fontWeight = style.weight
    }
}

// MARK: - Types
public extension Heading {

    enum Style {
        /// 28 pts.
        case title1
        /// 22 pts.
        case title2
        /// 18 pts.
        case title3
        /// 16 pts.
        case title4
        /// 15 pts.
        case title5
        /// 13 pts.
        case title6

        /// Font size.
        public var size: CGFloat {
            switch self {
                case .title1:           return 28
                case .title2:           return 22
                case .title3:           return 18
                case .title4:           return 16
                case .title5:           return 15
                case .title6:           return 13
            }
        }

        public var lineHeight: CGFloat {
            switch self {
                case .title1:           return 32
                case .title2:           return 28
                case .title3:           return 24
                case .title4:           return 20
                case .title5:           return 20
                case .title6:           return 16
            }
        }

        /// Icon size matching heading line height.
        public var iconSize: Icon.Size {
            .custom(lineHeight)
        }

        public var weight: Font.Weight {
            switch self {
                case .title1, .title4, .title5, .title6:    return .bold
                case .title2, .title3:                      return .medium
            }
        }

        public var textSize: Text.Size {
            .custom(size, lineHeight: lineHeight)
        }
    }
}

// MARK: - TextRepresentable
extension Heading: TextRepresentable {

    public func swiftUIText(sizeCategory: ContentSizeCategory, textAccentColor: Color?) -> SwiftUI.Text? {
        if content.isEmpty { return nil }

        return text(sizeCategory: sizeCategory, textAccentColor: textAccentColor)
    }
}

// MARK: - Previews
struct HeadingPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            formatted
            sizes
            lineHeight
            lineSpacing
            concatenated
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Heading("Heading", style: .title1)
            Heading("", style: .title1) // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var formatted: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            Group {
                Heading("Multiline\nlong heading", style: .title2)
                    .foregroundColor(.inkNormal)
                    .textAccentColor(.greenDark)
                    .kerning(5)
                    .strikethrough()
                    .underline()

                Heading("Multiline\n<ref>long</ref> heading", style: .title2)
                    .foregroundColor(nil)
                    .textAccentColor(.redNormal)
                    .kerning(5)
                    .strikethrough()
                    .underline()

                Heading("Multiline\n<applink1>long</applink1> heading", style: .title2)
                    .foregroundColor(.orangeNormal)
                    .textAccentColor(.blueDark)
                    .kerning(5)
                    .strikethrough()
                    .underline()
            }
            .multilineTextAlignment(.trailing)
            .lineSpacing(10)
            .border(.cloudNormal)
        }
        .foregroundColor(.blueNormal)
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var sizes: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            formattedHeading("<ref><u>Title 1</u></ref> with a very large and <strong>multiline</strong> content", style: .title1)
            formattedHeading("<ref><u>Title 2</u></ref> with a very very large and <strong>multiline</strong> content", style: .title2)
            formattedHeading("<ref><u>Title 3</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .title3)
            formattedHeading("<ref><u>Title 4</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .title4)
            formattedHeading("<ref><u>Title 5</u></ref> with a very very very very very large and <strong>multiline</strong> content", style: .title5, color: .blueDarker)
            formattedHeading("<ref><u>TITLE 6</u></ref> WITH A VERY VERY VERY VERY VERY LARGE AND <strong>MULTILINE</strong> CONTENT", style: .title6, color: nil)
        }
        .foregroundColor(.inkNormal)
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineHeight: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                LineHeight(style: .title1, formatted: false)
                LineHeight(style: .title2, formatted: false)
                LineHeight(style: .title3, formatted: false)
                LineHeight(style: .title4, formatted: false)
                LineHeight(style: .title5, formatted: false)
                LineHeight(style: .title6, formatted: false)
            }

            VStack(alignment: .trailing, spacing: .xxxSmall) {
                LineHeight(style: .title1, formatted: true)
                LineHeight(style: .title2, formatted: true)
                LineHeight(style: .title3, formatted: true)
                LineHeight(style: .title4, formatted: true)
                LineHeight(style: .title5, formatted: true)
                LineHeight(style: .title6, formatted: true)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineSpacing: some View {
        HStack(alignment: .top, spacing: .xxxSmall) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                Group {
                    Heading("Single line", style: .title2)
                        .background(Color.redLightHover)
                    Heading("<applink1>Single</applink1> line", style: .title2)
                        .background(Color.redLightHover.opacity(0.7))
                    Heading("<strong>Single</strong> line", style: .title2)
                        .background(Color.redLightHover.opacity(0.4))
                }
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            }

            Group {
                Heading("Multiline\nwith\n<strong>formatting</strong>", style: .title2)
                Heading("Multiline\nwith\n<applink1>links</applink1>", style: .title2)
            }
            .lineSpacing(.xxxSmall)
            .background(Color.redLightHover.opacity(0.7))
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var concatenated: some View {
        Group {
            Icon(.grid)
            +
            Heading(" <ref><u>Title 4</u></ref> with <strong>multiline</strong>", style: .title4)
            +
            Heading(" <ref><u>Title 5</u></ref> with <strong>multiline</strong>", style: .title5)
                .foregroundColor(.greenDark)
                .textAccentColor(.blueDarker)
            +
            Heading(" <ref><u>TITLE 6</u></ref> WITH <strong>MULTILINE</strong> CONTENT", style: .title6)
                .foregroundColor(nil)
            +
            Text(" and Text")
                .foregroundColor(nil)
        }
        .foregroundColor(.inkDark)
        .padding(.medium)
        .previewDisplayName()
    }

    static func formattedHeading(_ content: String, style: Heading.Style, color: Color? = .inkDark) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Heading(content, style: style)
                .foregroundColor(color)
                .textAccentColor(.blueNormal)
            Spacer()
            Text("\(Int(style.size))/\(Int(style.lineHeight))")
                .foregroundColor(.inkNormal)
                .fontWeight(.medium)
        }
    }

    struct LineHeight: View {

        @Environment(\.sizeCategory) var sizeCategory
        let style: Heading.Style
        let formatted: Bool

        var body: some View {
            HStack(spacing: .xxSmall) {
                Heading(
                    "\(formatted ? "<ref>" : "")\(String(describing:style).capitalized)\(formatted ? "</ref>" : "")",
                    style: style
                )
                .textAccentColor(Status.info.darkColor)
                .fixedSize()
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)

                Text("\(style.size.formatted) / \(style.lineHeight.formatted)", size: .custom(6))
                    .environment(\.sizeCategory, .large)
            }
            .padding(.trailing, .xxSmall)
            .border(.redNormal, width: .hairline)
            .measured()
            .padding(.trailing, 40 * sizeCategory.controlRatio)
            .overlay(
                SwiftUI.Text("T")
                    .orbitFont(size: style.size, sizeCategory: sizeCategory)
                    .border(.redNormal, width: .hairline)
                    .measured()
                ,
                alignment: .trailing
            )
        }
    }
}

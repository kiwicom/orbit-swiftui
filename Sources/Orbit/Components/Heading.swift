import SwiftUI

/// Shows the content hierarchy and improves the reading experience. Also known as Title.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/heading/)
/// - Important: Component has fixed vertical size.
public struct Heading: View {

    @Environment(\.sizeCategory) var sizeCategory

    let content: String
    let style: Style
    let color: Color?
    let lineSpacing: CGFloat?
    let alignment: TextAlignment
    let accentColor: UIColor

    public var body: some View {
        if content.isEmpty == false {
            text(sizeCategory: sizeCategory)
                .multilineTextAlignment(alignment)
                .fixedSize(horizontal: false, vertical: true)
                .accessibility(addTraits: .isHeader)
        }
    }

    func text(sizeCategory: ContentSizeCategory) -> SwiftUI.Text {
        Text(
            content,
            size: .custom(style.size),
            color: color?.textColor,
            weight: style.weight,
            lineSpacing: lineSpacing,
            alignment: alignment,
            accentColor: accentColor,
            isSelectable: false
        )
        .text(sizeCategory: sizeCategory)
    }
}

// MARK: - Inits
public extension Heading {

    /// Creates Orbit Heading component.
    ///
    /// - Parameters:
    ///   - content: String to display. Supports html formatting tags `<strong>`, `<u>`, `<ref>`.
    ///   - style: Heading style.
    ///   - color: Font color. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    ///   - lineSpacing: Distance in points between the bottom of one line fragment and the top of the next.
    ///   - alignment: Horizontal multi-line alignment.
    ///   - accentColor: Color for `<ref>` formatting tag.
    ///   - linkColor: Color for `<a href>` and `<applink>` formatting tag.
    init(
        _ content: String,
        style: Style,
        color: Color? = .inkDark,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading,
        accentColor: UIColor? = nil
    ) {
        self.content = content
        self.style = style
        self.color = color
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.accentColor = accentColor ?? color?.uiValue ?? .inkDark
    }
}

// MARK: - Types
public extension Heading {

    /// Orbit Heading color.
    enum Color: Equatable {
        /// The default Heading color.
        case inkDark
        /// Custom Heading color.
        case custom(UIColor)

        public var value: SwiftUI.Color {
            SwiftUI.Color(uiValue)
        }

        public var uiValue: UIColor {
            switch self {
                case .inkDark:              return .inkDark
                case .custom(let color):    return color
            }
        }

        public var textColor: Text.Color? {
            switch self {
                case .inkDark:              return .inkDark
                case .custom(let color):    return .custom(color)
            }
        }
    }

    enum Style {
        /// 40 pts.
        case display
        /// 22 pts.
        case displaySubtitle
        /// 28 pts.
        case title1
        /// 22 pts.
        case title2
        /// 18 pts.
        case title3
        /// 16 pts.
        case title4
        /// 14 pts.
        case title5
        /// 12 pts.
        case title6

        public var size: CGFloat {
            switch self {
                case .display:          return 40
                case .displaySubtitle:  return 22
                case .title1:           return 28
                case .title2:           return 22
                case .title3:           return Text.Size.xLarge.value
                case .title4:           return Text.Size.large.value
                case .title5:           return Text.Size.normal.value
                case .title6:           return Text.Size.small.value
            }
        }

        public var textStyle: Font.TextStyle {
            switch self {
                case .display:
                    return .largeTitle
                case .displaySubtitle:
                    if #available(iOS 14.0, *) {
                        return .title2
                    } else {
                        return .headline
                    }
                case .title1:
                    return .title
                case .title2:
                    if #available(iOS 14.0, *) {
                        return .title2
                    } else {
                        return .headline
                    }
                case .title3:
                    if #available(iOS 14.0, *) {
                        return .title3
                    } else {
                        return .callout
                    }
                case .title4:
                    return .callout
                case .title5:
                    return .headline
                case .title6:
                    return .headline
            }
        }

        public var lineHeight: CGFloat {
            switch self {
                case .display:          return 48
                case .displaySubtitle:  return 28
                case .title1:           return 32
                case .title2:           return 28
                case .title3:           return Text.Size.large.lineHeight
                case .title4:           return Text.Size.normal.lineHeight
                case .title5:           return Text.Size.normal.lineHeight
                case .title6:           return Text.Size.small.lineHeight
            }
        }

        public var iconSize: CGFloat {
            switch self {
                case .display:          return 52
                case .displaySubtitle:  return 30
                case .title1:           return 38
                case .title2:           return 30
                case .title3:           return 26
                case .title4:           return 22
                case .title5:           return 20
                case .title6:           return 18
            }
        }

        public var weight: Font.Weight {
            switch self {
                case .display, .title1, .title4, .title5, .title6:      return .bold
                case .displaySubtitle, .title2, .title3:                return .medium
            }
        }
    }
}

// MARK: - TextRepresentable
extension Heading: TextRepresentable {

    public func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        if content.isEmpty { return nil }

        return text(sizeCategory: sizeCategory)
    }
}

// MARK: - Previews
struct HeadingPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizes
            multiline
            concatenated
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Heading("Heading", style: .title1)
            Heading("", style: .title1) // EmptyView
        }
        .previewDisplayName("Heading")
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("Display Title", style: .display)
            heading("Display Subtitle", style: .displaySubtitle)
            Separator()
                .padding(.vertical, .small)
            heading("Title 1", style: .title1)
            heading("Title 2", style: .title2)
            heading("Title 3", style: .title3)
            heading("Title 4", style: .title4)
            heading("Title 5", style: .title5)
            heading("TITLE 6", style: .title6)
        }
        .previewDisplayName("Styles")
    }
    
    static var multiline: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("<ref><u>Display title</u></ref> with a very large and <strong>multiline</strong> content", style: .display)
            heading("<ref><u>Display subtitle</u></ref> with a very large and <strong>multiline</strong> content", style: .displaySubtitle)
            Separator()
                .padding(.vertical, .small)
            heading("<ref><u>Title 1</u></ref> with a very large and <strong>multiline</strong> content", style: .title1)
            heading("<ref><u>Title 2</u></ref> with a very very large and <strong>multiline</strong> content", style: .title2)
            heading("<ref><u>Title 3</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .title3)
            heading("<ref><u>Title 4</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .title4)
            heading("<ref><u>Title 5</u></ref> with a very very very very very large and <strong>multiline</strong> content", style: .title5, color: .custom(.blueDarker))
            heading("<ref><u>TITLE 6</u></ref> WITH A VERY VERY VERY VERY VERY LARGE AND <strong>MULTILINE</strong> CONTENT", style: .title6, color: nil)
        }
        .foregroundColor(.inkNormal)
        .previewDisplayName("Multiline")
    }

    static var concatenated: some View {
        Group {
            Heading("<ref><u>Title 4</u></ref> with <strong>multiline</strong>", style: .title4)
            +
            Heading(" <ref><u>Title 5</u></ref> with <strong>multiline</strong>", style: .title5, color: .custom(.greenDark), accentColor: .blueDarker)
            +
            Heading(" <ref><u>TITLE 6</u></ref> WITH <strong>MULTILINE</strong> CONTENT", style: .title6, color: nil)
        }
        .foregroundColor(.inkNormal)
        .previewDisplayName("Concatenated")
    }

    static var snapshot: some View {
        sizes
            .padding(.medium)
    }

    @ViewBuilder static func heading(_ content: String, style: Heading.Style, color: Heading.Color? = .inkDark) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Heading(content, style: style, color: color, accentColor: .blueNormal)
            Spacer()
            Text("\(Int(style.size))/\(Int(style.lineHeight))", color: .inkNormal, weight: .medium)
        }
    }
}

import SwiftUI

/// Shows the content hierarchy and improves the reading experience. Also known as Title.
///
/// - Related components:
///   - ``Text``

/// - Note: [Orbit definition](https://orbit.kiwi/components/heading/)
/// - Important: Component has fixed vertical size.
public struct Heading: View {

    let label: String
    let style: Style
    let color: Color?
    let alignment: TextAlignment

    public var body: some View {
        if text.isEmpty == false {
            SwiftUI.Text(verbatim: text)
                .font(.orbit(size: style.size, weight: style.weight))
                .foregroundColor(color?.value)
                .multilineTextAlignment(alignment)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    var text: String {
        switch style {
            case .display, .title1, .displaySubtitle, .title2, .title3, .title4, .title5:   return label
            case .title6:                                                                   return label.localizedUppercase
        }
    }
}

// MARK: - Inits
public extension Heading {

    /// Creates Orbit Heading component.
    init(
        _ label: String,
        style: Style,
        color: Color? = .inkNormal,
        alignment: TextAlignment = .leading
    ) {
        self.label = label
        self.style = style
        self.color = color
        self.alignment = alignment
    }
}

// MARK: - Types
public extension Heading {

    enum Color: Equatable {
        case inkNormal
        case custom(_ color: SwiftUI.Color)

        public var value: SwiftUI.Color {
            switch self {
                case .inkNormal:            return .inkNormal
                case .custom(let color):    return color
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

// MARK: - Previews
struct HeadingPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizes
            multiline
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Heading("Heading", style: .title1)
            Heading("", style: .title1) // EmptyView
        }
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("Display Title", style: .display)
            heading("Display Subtitle", style: .displaySubtitle)
            Separator()
            heading("Title 1", style: .title1)
            heading("Title 2", style: .title2)
            heading("Title 3", style: .title3)
            heading("Title 4", style: .title4)
            heading("Title 5", style: .title5)
            heading("Title 6", style: .title6)
        }
        .padding(.medium)
    }
    
    static var multiline: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("Display title with a very large and multine content", style: .display)
            heading("Display subtitle with a very large and multine content", style: .displaySubtitle)
            Separator()
            heading("Title 1 with a very large and multine content", style: .title1)
            heading("Title 2 with a very very large and multine content", style: .title2)
            heading("Title 3 with a very very very very large and multine content", style: .title3)
            heading("Title 4 with a very very very very large and multine content", style: .title4)
            heading("Title 5 with a very very very very very large and multine content", style: .title5)
            heading("Title 6 with a very very very very very large and multine content", style: .title6)
        }
        .padding(.medium)
        .previewDisplayName("Multiline")
    }

    @ViewBuilder static func heading(_ content: String, style: Heading.Style) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Heading(content, style: style)
            Spacer()
            Text("\(Int(style.size))/\(Int(style.lineHeight))", color: .inkLight, weight: .medium)
        }
    }
}

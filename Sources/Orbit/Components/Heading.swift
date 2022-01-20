import SwiftUI

/// Shows the content hierarchy and improves the reading experience. Also known as Title.
///
/// - Related components:
///   - ``Text``

/// - Note: [Orbit definition](https://orbit.kiwi/components/heading/)
/// - Important: Component has fixed vertical size.
public struct Heading: View {

    public static let spacing: CGFloat = .xSmall

    let label: String
    let iconContent: Icon.Content
    let style: Style
    let color: Color?
    let alignment: TextAlignment

    public var body: some View {
        
        if text.isEmpty == false || iconContent.isEmpty == false {
            
            HStack(alignment: .firstTextBaseline, spacing: Self.spacing) {
                iconContent.view()
                    .alignmentGuide(.firstTextBaseline) { size in
                        self.style.size * Text.firstBaselineRatio + size.height / 2
                    }

                if text.isEmpty == false {
                    SwiftUI.Text(verbatim: text)
                        .font(.orbit(size: style.size, weight: style.weight))
                        .multilineTextAlignment(alignment)
                        .foregroundColor(color?.value)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    var text: String {
        switch style {
            case .display, .title1, .displaySubtitle, .title2, .title3, .title4:    return label
            case .title5:                                                           return label.localizedUppercase
        }
    }
}

// MARK: - Inits
public extension Heading {

    /// Creates Orbit Heading component.
    init(
        _ label: String,
        iconContent: Icon.Content = .none,
        style: Style,
        color: Color? = .inkNormal,
        alignment: TextAlignment = .leading
    ) {
        self.label = label
        self.iconContent = iconContent
        self.style = style
        self.color = color
        self.alignment = alignment
    }

    /// Creates Orbit Heading component with icon symbol.
    init(
        _ label: String,
        icon: Icon.Symbol,
        style: Style,
        color: Color? = .inkNormal,
        alignment: TextAlignment = .leading
    ) {
        self.label = label
        self.iconContent = .icon(icon, size: .custom(style.size), color: color?.value)
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
        case display
        case displaySubtitle
        case title1
        case title2
        case title3
        case title4
        case title5

        public var size: CGFloat {
            switch self {
                case .display:          return 40
                case .displaySubtitle:  return 22
                case .title1:           return 28
                case .title2:           return 22
                case .title3:           return Text.Size.large.value
                case .title4:           return Text.Size.normal.value
                case .title5:           return Text.Size.small.value
            }
        }

        public var weight: Font.Weight {
            switch self {
                case .display, .title1:                                         return .bold
                case .displaySubtitle, .title2, .title3, .title4, .title5:      return .medium
            }
        }
    }
}

// MARK: - Previews
struct HeadingPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Heading("Heading", style: .title1)
    }

    static var orbit: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Heading("Display title", style: .display)
            Heading("Display subtitle", style: .displaySubtitle)
            Separator()
            Heading("Title 1", style: .title1)
            Heading("Title 2", style: .title2)
            Heading("Title 3", style: .title3)
            Heading("Title 4", style: .title4)
            Heading("Title 5", style: .title5)
        }
        .previewDisplayName("Orbit")
    }

    static var snapshots: some View {
        Group {
            orbit
                .padding(.vertical)

            VStack(alignment: .leading, spacing: .xSmall) {
                Heading("Display title, but very very very very very very very long", icon: .circle, style: .display)
                Heading("Display subtitle, also very very very very very long", icon: .email, style: .displaySubtitle)
                Separator()
                Heading("Title 1, also very very very very very very very verylong", icon: .circle, style: .title1)
                Heading("Title 2, but very very very very very very very very long", icon: .circle, style: .title2)
                Heading("Title 3, but very very very very very very very very long", icon: .circle, style: .title3)
                Heading("Title 4, but very very very very very very very very long", icon: .circle, style: .title4)
                Heading("Title 5, but very very very very very very very very long", icon: .circle, style: .title5)
            }
            .padding(.vertical)
            .previewDisplayName("Longer text")
        }
        .padding(.horizontal)
    }
}

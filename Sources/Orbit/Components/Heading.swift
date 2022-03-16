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
            
            Label("Heading", icon: .grid, titleStyle: .heading(.title1, color: nil))
                .foregroundColor(.blueNormal)
                .previewDisplayName("Label with color override")
            
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
            Heading("Title 6", style: .title6)
        }
        .previewDisplayName("Orbit")
    }

    static var snapshots: some View {
        Group {
            orbit
                .padding(.vertical)

            VStack(alignment: .leading, spacing: .xSmall) {
                Label("Display title, but very very very very very very very long", icon: .circle, titleStyle: .display)
                
                Label("Display title, but very very very very very very very long", icon: .circle, titleStyle: .display)
                
                Label("Display subtitle, also very very very very very long", icon: .email, titleStyle: .displaySubtitle)
                Separator()
                Label("Title 1, also very very very very very very very verylong", icon: .circle, titleStyle: .title1)
                Label("Title 2, but very very very very very very very very long", icon: .circle, titleStyle: .title2)
                Label("Title 3, but very very very very very very very very long", icon: .circle, titleStyle: .title3)
                Label("Title 4, but very very very very very very very very long", icon: .circle, titleStyle: .title4)
                Label("Title 5, but very very very very very very very very long", icon: .circle, titleStyle: .title5)
                Label("Title 6, but very very very very very very very very long", icon: .circle, titleStyle: .title6)
            }
            .padding(.vertical)
            .previewDisplayName("Longer text with icon using Label")
        }
        .padding(.horizontal)
    }
}

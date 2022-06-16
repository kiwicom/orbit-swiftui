import SwiftUI

/// Presents a list of short details with added visual information.
///
/// The items in the list should all be static information, *not* actionable.
///
/// - Related components:
///   - ``Badge``
///   - ``List``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/badgelist/)
public struct BadgeList: View {

    public static let spacing: CGFloat = .xSmall

    let label: String
    let iconContent: Icon.Content
    let style: Style
    let labelColor: LabelColor
    let linkAction: TextLink.Action

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: Self.spacing) {
                Icon(content: iconContent, size: .small)
                    .foregroundColor(style.iconColor)
                    .padding(.xxSmall)
                    .background(badgeBackground)

                Text(
                    label,
                    size: .small,
                    color: .custom(labelColor.color),
                    linkColor: .custom(labelColor.color),
                    linkAction: linkAction
                )
            }
        }
    }

    @ViewBuilder var badgeBackground: some View {
        style.backgroundColor
            .clipShape(Circle())
    }

    var isEmpty: Bool {
        label.isEmpty && iconContent.isEmpty
    }
}

// MARK: - Inits
public extension BadgeList {

    /// Creates Orbit BadgeList component.
    init(
        _ label: String = "",
        icon: Icon.Content = .none,
        style: Style = .neutral,
        labelColor: LabelColor = .default,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.label = label
        self.iconContent = icon
        self.style = style
        self.labelColor = labelColor
        self.linkAction = linkAction
    }
}

// MARK: - Types
public extension BadgeList {

    enum Style: Equatable, Hashable {

        case neutral
        case status(_ status: Status)
        case custom(iconColor: SwiftUI.Color, backgroundColor: SwiftUI.Color)

        public var backgroundColor: Color {
            switch self {
                case .neutral:                              return .cloudLight
                case .status(.info):                        return .blueLight
                case .status(.success):                     return .greenLight
                case .status(.warning):                     return .orangeLight
                case .status(.critical):                    return .redLight
                case .custom(_, let backgroundColor):       return backgroundColor
            }
        }

        public var iconColor: Color {
            switch self {
                case .neutral:                              return .inkLight
                case .status(.info):                        return .blueNormal
                case .status(.success):                     return .greenNormal
                case .status(.warning):                     return .orangeNormal
                case .status(.critical):                    return .redNormal
                case .custom(let iconColor, _):             return iconColor
            }
        }
    }

    enum LabelColor {
        case `default`
        case custom(_ color: UIColor)

        var color: UIColor {
            switch self {
                case .default:              return .inkLight
                case .custom(let color):    return color
            }
        }
    }
}

// MARK: - Previews
struct BadgeListPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(alignment: .leading, spacing: 0) {
            BadgeList("Neutral BadgeList", icon: .grid)
            BadgeList()   // EmptyView
            BadgeList("") // EmptyView
        }
        .padding(.medium)
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList("This is simple Neutral BadgeList item with <u>very long</u> and <strong>formatted</strong> multiline content with a <a href=\".\">TextLink</a>", icon: .grid)
            BadgeList("This is simple Info BadgeList item", icon: .informationCircle, style: .status(.info))
            BadgeList("This is simple Success BadgeList item", icon: .checkCircle, style: .status(.success))
            BadgeList("This is simple Warning BadgeList item", icon: .alertCircle, style: .status(.warning))
            BadgeList("This is simple Critical BadgeList item", icon: .alertCircle, style: .status(.critical))
        }
        .padding(.medium)
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList("This is simple Info BadgeList item with SF Symbol", icon: .sfSymbol("info.circle.fill"), style: .status(.info))
            BadgeList("This is simple Info BadgeList item with CountryFlag", icon: .countryFlag("cz"), style: .status(.critical))
            BadgeList("This is simple Info BadgeList item with custom image", icon: .image(.orbit(.facebook)), style: .status(.success))
        }
        .padding(.medium)
    }
}

struct BadgeListDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        BadgeListPreviews.standalone
    }
}

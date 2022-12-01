import SwiftUI

/// Presents a list of short details with added visual information.
///
/// The items in the list should all be static information, *not* actionable.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/badgelist/)
public struct BadgeList: View {

    public static let spacing: CGFloat = .xSmall

    let label: String
    let iconContent: Icon.Content
    let style: Style
    let labelColor: LabelColor
    let size: Size
    let linkAction: TextLink.Action

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: Self.spacing) {
                badgeOrEmptySpace
                    .foregroundColor(.init(style.iconColor))
                    .padding(.xxSmall)
                    .background(badgeBackground)

                Text(
                    label,
                    size: size.textSize,
                    color: .custom(labelColor.color),
                    accentColor: style.iconColor,
                    linkColor: .custom(labelColor.color),
                    linkAction: linkAction
                )
            }
        }
    }

    @ViewBuilder var badgeOrEmptySpace: some View {
        if iconContent.isEmpty {
            Icon(content: .grid, size: .small)
                .opacity(0)
        } else {
            Icon(content: iconContent, size: .small)
        }
    }

    @ViewBuilder var badgeBackground: some View {
        if iconContent.isEmpty == false {
            style.backgroundColor
                .clipShape(Circle())
        }
    }

    var isEmpty: Bool {
        label.isEmpty && iconContent.isEmpty
    }

    var textLeadingPadding: CGFloat {
        iconContent.isEmpty ? (Icon.Size.small.value + Self.spacing) : 0
    }
}

// MARK: - Inits
public extension BadgeList {

    /// Creates Orbit BadgeList component.
    init(
        _ label: String = "",
        icon: Icon.Content = .none,
        style: Style = .neutral,
        labelColor: LabelColor = .primary,
        size: Size = .normal,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.label = label
        self.iconContent = icon
        self.style = style
        self.labelColor = labelColor
        self.size = size
        self.linkAction = linkAction
    }
}

// MARK: - Types
public extension BadgeList {

    enum Style: Equatable, Hashable {

        case neutral
        case status(_ status: Status)
        case custom(iconColor: UIColor, backgroundColor: SwiftUI.Color)

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

        public var iconColor: UIColor {
            switch self {
                case .neutral:                              return .inkNormal
                case .status(.info):                        return .blueNormal
                case .status(.success):                     return .greenNormal
                case .status(.warning):                     return .orangeNormal
                case .status(.critical):                    return .redNormal
                case .custom(let iconColor, _):             return iconColor
            }
        }
    }

    enum LabelColor {
        case primary
        case secondary
        case custom(_ color: UIColor)

        var color: UIColor {
            switch self {
                case .primary:              return .inkDark
                case .secondary:            return .inkNormal
                case .custom(let color):    return color
            }
        }
    }

    enum Size {
        case small
        case normal
        case custom(_ size: Text.Size)

        var textSize: Text.Size {
            switch self {
                case .small:              	return .small
                case .normal:               return .normal
                case .custom(let size):     return size
            }
        }
    }
}

// MARK: - Previews
struct BadgeListPreviews: PreviewProvider {

    static let label = "This is simple BadgeList item"
    static let longLabel = "This is simple Neutral BadgeList item with <u>very long</u> and <strong>formatted</strong> multiline content with a <a href=\".\">TextLink</a>"

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneSmallSecondary
            statuses
            mix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(alignment: .leading, spacing: 0) {
            BadgeList("Neutral BadgeList", icon: .grid)
            BadgeList()   // EmptyView
            BadgeList("") // EmptyView
        }
        .previewDisplayName()
    }

    static var standaloneSmallSecondary: some View {
        BadgeList("Neutral BadgeList", icon: .grid, labelColor: .secondary, size: .small)
            .previewDisplayName()
    }

    static var statuses: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid)
                BadgeList(label, icon: .informationCircle, style: .status(.info))
                BadgeList(label, icon: .checkCircle, style: .status(.success))
                BadgeList(label, icon: .alertCircle, style: .status(.warning))
                BadgeList(label, icon: .alertCircle, style: .status(.critical))
            }
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid, labelColor: .secondary, size: .small)
                BadgeList(label, icon: .informationCircle, style: .status(.info), labelColor: .secondary, size: .small)
                BadgeList(label, icon: .checkCircle, style: .status(.success), labelColor: .secondary, size: .small)
                BadgeList(label, icon: .alertCircle, style: .status(.warning), labelColor: .secondary, size: .small)
                BadgeList(label, icon: .alertCircle, style: .status(.critical), labelColor: .secondary, size: .small)
            }
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>SF Symbol</strong>", icon: .sfSymbol("info.circle.fill"), style: .status(.info))
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>CountryFlag</strong>", icon: .countryFlag("cz"), style: .status(.critical))
            BadgeList("This is simple <ref>BadgeList</ref> item with custom image", icon: .image(.orbit(.facebook)), style: .status(.success))
            BadgeList("This is <ref>BadgeList</ref> item with no icon and custom color", labelColor: .custom(.blueDark))
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        statuses
            .padding(.medium)
    }
}

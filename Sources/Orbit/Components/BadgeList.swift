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

    public static let badgeDiameter = Spacing.large
    public static let spacing = Spacing.xSmall

    let label: String
    let iconContent: Icon.Content
    let style: Style
    let labelColor: LabelColor

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Self.spacing) {
            badgeBackground
                .overlay(Icon(iconContent))
                .alignmentGuide(.firstTextBaseline) { size in
                    Text.Size.small.value * Text.firstBaselineRatio + size.height / 2
                }

            Text(
                label,
                size: .small,
                color: .custom(labelColor.color),
                linkColor: labelColor.color
            )
        }
    }

    @ViewBuilder var badgeBackground: some View {
        style.backgroundColor
            .clipShape(Circle())
            .frame(width: Self.badgeDiameter, height: Self.badgeDiameter)
    }
}

// MARK: - Inits
public extension BadgeList {

    /// Creates Orbit BadgeList component.
    init(
        _ label: String = "",
        iconContent: Icon.Content = .none,
        style: Style = .neutral,
        labelColor: LabelColor = .default
    ) {
        self.label = label
        self.iconContent = iconContent
        self.style = style
        self.labelColor = labelColor
    }

    /// Creates Orbit BadgeList component with icon symbol.
    init(_ label: String = "", icon: Icon.Symbol = .none, style: Style = .neutral, labelColor: LabelColor = .default) {
        self.init(
            label,
            iconContent: .icon(icon, size: .small, color: style.iconColor),
            style: style,
            labelColor: labelColor
        )
    }

    /// Creates Orbit BadgeList component with no icon.
    init(_ label: String = "", style: Style = .neutral, labelColor: LabelColor = .default) {
        self.init(label, iconContent: .none, style: style, labelColor: labelColor)
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
public struct BadgeListPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
                .previewDisplayName("Orbit")
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        BadgeList("Neutral BadgeList", icon: .wifi)
    }

    static var orbit: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            standalone
            BadgeList("Info BadgeList", icon: .informationCircle, style: .status(.info))
            BadgeList("Success BadgeList", icon: .checkCircle, style: .status(.success))
            BadgeList("Warning BadgeList", icon: .alertCircle, style: .status(.warning))
            BadgeList("Critical BadgeList", icon: .alertCircle, style: .status(.critical))
        }
    }

    static var snapshots: some View {
        orbit
            .padding(.medium)
    }
}

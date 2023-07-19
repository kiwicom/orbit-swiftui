import SwiftUI

/// Presents a list of short details with added visual information.
///
/// The items in the list should all be static information, *not* actionable.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/badgelist/)
public struct BadgeList<Icon: View, Content: View>: View, PotentiallyEmptyView {

    @Environment(\.status) private var status
    @Environment(\.textAccentColor) private var textAccentColor
    @Environment(\.textColor) private var textColor

    let type: BadgeListType
    @ViewBuilder let icon: Icon
    @ViewBuilder let content: Content

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                badge
                    .font(.system(size: Orbit.Icon.Size.small.value))
                    .foregroundColor(iconColor)
                    .iconColor(iconColor)
                    .padding(.xxSmall)
                    .background(badgeBackground)

                content
                    .textAccentColor(textAccentColor ?? iconColor)
                    .textLinkColor(.custom(textColor ?? .inkDark))
            }
        }
    }

    @ViewBuilder var badge: some View {
        if icon.isEmpty {
            Orbit.Icon(.grid)
                .iconSize(.small)
                .opacity(0)
        } else {
            icon
        }
    }

    @ViewBuilder var badgeBackground: some View {
        if icon.isEmpty == false {
            backgroundColor
                .clipShape(Circle())
        }
    }

    public var iconColor: Color {
        switch type {
            case .neutral:                              return .inkNormal
            case .status(let status):                   return (status ?? defaultStatus).color
            case .custom(let iconColor, _):             return iconColor
        }
    }

    public var backgroundColor: Color {
        switch type {
            case .neutral:                              return .cloudLight
            case .status(let status):                   return (status ?? defaultStatus).lightColor
            case .custom(_, let backgroundColor):       return backgroundColor
        }
    }

    var defaultStatus: Status {
        status ?? .info
    }

    var isEmpty: Bool {
        content.isEmpty && icon.isEmpty
    }
}

// MARK: - Inits
public extension BadgeList {

    /// Creates Orbit BadgeList component.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String = "",
        icon: Icon.Symbol? = nil,
        type: BadgeListType = .neutral
    ) where Icon == Orbit.Icon, Content == Text {
        self.init(label, type: type) {
            Icon(icon)
                .iconSize(.small)
        }
    }

    /// Creates Orbit BadgeList component with custom icon.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String = "",
        type: BadgeListType = .neutral,
        @ViewBuilder icon: () -> Icon
    ) where Content == Text {
        self.init(type: type) {
            Text(label)
        } icon: {
            icon()
        }
    }

    /// Creates Orbit BadgeList component with custom icon and content.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        type: BadgeListType = .neutral,
        @ViewBuilder content: () -> Content,
        @ViewBuilder icon: () -> Icon
    ) {
        self.type = type
        self.icon = icon()
        self.content = content()
    }
}

// MARK: - Types

public enum BadgeListType: Equatable, Hashable {
    case neutral
    case status(_ status: Status?)
    case custom(iconColor: Color, backgroundColor: Color)
}

// MARK: - Previews
struct BadgeListPreviews: PreviewProvider {

    static let label = "This is simple BadgeList item"
    static let longLabel = "This is simple Neutral BadgeList item with <u>very long</u> and <strong>formatted</strong> multiline content with a <a href=\".\">TextLink</a>"

    static var previews: some View {
        PreviewWrapper {
            standalone
            smallSecondary
            styles
            mix
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
        .previewDisplayName()
    }

    static var smallSecondary: some View {
        BadgeList("Neutral BadgeList", icon: .grid)
            .textSize(.small)
            .textColor(.inkLight)
            .padding(.medium)
            .previewDisplayName()
    }

    static var styles: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid)
                BadgeList(label, icon: .informationCircle, type: .status(.info))
                BadgeList(label, icon: .checkCircle, type: .status(.success))
                BadgeList(label, icon: .alertCircle, type: .status(.warning))
                BadgeList(label, icon: .alertCircle, type: .status(.critical))
            }
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid)
                BadgeList(label, icon: .informationCircle, type: .status(.info))
                BadgeList(label, icon: .checkCircle, type: .status(.success))
                BadgeList(label, icon: .alertCircle, type: .status(.warning))
                BadgeList(label, icon: .alertCircle, type: .status(.critical))
            }
            .textColor(.inkNormal)
            .textSize(.small)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>SF Symbol</strong>", type: .status(.info)) {
                Icon("info.circle.fill")
            }
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>CountryFlag</strong>", type: .status(.critical)) {
                CountryFlag("us")
            }
            BadgeList("This is <ref>BadgeList</ref> item with no icon and custom color")
                .textColor(.blueDark)
            BadgeList("This is a <ref>BadgeList</ref> with <strong>status</strong> override", type: .status(nil)) {
                Icon("info.circle.fill")
            }
        }
        .iconSize(.small)
        .status(.success)
        .padding(.medium)
        .previewDisplayName()
    }
}

import SwiftUI

/// Presents a list of short details with added visual information.
///
/// The items in the list should all be static information, *not* actionable.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/badgelist/)
public struct BadgeList: View {

    @Environment(\.status) private var status
    @Environment(\.textAccentColor) private var textAccentColor
    @Environment(\.textColor) private var textColor

    let label: String
    let icon: Icon.Content?
    let style: Style
    let labelColor: LabelColor
    let size: Size

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                Icon(icon, size: .small)
                    .textColor(iconColor)
                    .padding(.xxSmall)
                    .background(badgeBackground)

                Text(label, size: size.textSize)
                    .textColor(textColor ?? labelColor.color)
                    .textAccentColor(textAccentColor ?? iconColor)
                    .textLinkColor(.custom(labelColor.color))
            }
        }
    }

    @ViewBuilder var badgeBackground: some View {
        if isIconEmpty == false, icon != .transparent {
            backgroundColor
                .clipShape(Circle())
        }
    }

    public var iconColor: Color {
        switch style {
            case .neutral:                              return .inkNormal
            case .status(let status):                   return (status ?? defaultStatus).color
            case .custom(let iconColor, _):             return iconColor
        }
    }

    public var backgroundColor: Color {
        switch style {
            case .neutral:                              return .cloudLight
            case .status(let status):                   return (status ?? defaultStatus).lightColor
            case .custom(_, let backgroundColor):       return backgroundColor
        }
    }

    var defaultStatus: Status {
        status ?? .info
    }

    var isEmpty: Bool {
        label.isEmpty && isIconEmpty
    }

    var isIconEmpty: Bool {
        icon?.isEmpty ?? true
    }
}

// MARK: - Inits
public extension BadgeList {

    /// Creates Orbit BadgeList component.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String = "",
        icon: Icon.Content? = nil,
        style: Style = .neutral,
        labelColor: LabelColor = .primary,
        size: Size = .normal
    ) {
        self.label = label
        self.icon = icon
        self.style = style
        self.labelColor = labelColor
        self.size = size
    }
}

// MARK: - Types
public extension BadgeList {

    enum Style: Equatable, Hashable {

        case neutral
        case status(_ status: Status?)
        case custom(iconColor: Color, backgroundColor: Color)
    }

    enum LabelColor {
        case primary
        case secondary
        case custom(_ color: Color)

        var color: Color {
            switch self {
                case .primary:              return .inkDark
                case .secondary:            return .inkNormal
                case .custom(let color):    return color
            }
        }
    }

    enum Size: Equatable {
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
        BadgeList("Neutral BadgeList", icon: .grid, labelColor: .secondary, size: .small)
            .padding(.medium)
            .previewDisplayName()
    }

    static var styles: some View {
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
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>SF Symbol</strong>", icon: .sfSymbol("info.circle.fill"), style: .status(.info))
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>CountryFlag</strong>", icon: .countryFlag("cz"), style: .status(.critical))
            BadgeList("This is <ref>BadgeList</ref> item with no icon and custom color", labelColor: .custom(.blueDark))
            BadgeList("This is <ref>BadgeList</ref> item with transparent icon and custom color", icon: .transparent, labelColor: .custom(.blueDark))
            BadgeList("This is a <ref>BadgeList</ref> with <strong>status</strong> override", icon: .sfSymbol("info.circle.fill"), style: .status(nil))
        }
        .status(.success)
        .padding(.medium)
        .previewDisplayName()
    }
}

import SwiftUI

/// Orbit component that displays non-actionable, short details with added visual information.
///
/// A ``BadgeList`` consists of a description and icon.
///
/// ```swift
/// BadgeList("You must collect <applink1>your baggage</applink1>", icon: .baggage)
/// ```
///
/// ### Customizing appearance
///
/// The label color can be modified by ``textColor(_:)``:
/// 
/// ```swift
/// BadgeList("Label")
///     .textColor(.blueNormal)
/// ```
///
/// When type is set to ``BadgeListType/status(_:)`` with a `nil` value, the default ``Status/info`` status can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// BadgeList("Does not include guarantee", type: .status(nil))
///     .status(.warning)
/// ```
///
/// ### Layout
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/information/badgelist/)
public struct BadgeList<Icon: View, Label: View>: View, PotentiallyEmptyView {

    @Environment(\.status) private var status
    @Environment(\.textAccentColor) private var textAccentColor
    @Environment(\.textColor) private var textColor

    private let type: BadgeListType
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let label: Label

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                badge
                    .font(.system(size: Orbit.Icon.Size.small.value))
                    .foregroundColor(iconColor)
                    .iconColor(iconColor)
                    .padding(.xxSmall)
                    .background(badgeBackground)

                label
                    .textAccentColor(textAccentColor ?? iconColor)
                    .textLinkColor(.custom(textColor ?? .inkDark))
            }
        }
    }

    @ViewBuilder private var badge: some View {
        if icon.isEmpty {
            Orbit.Icon(.grid)
                .iconSize(.small)
                .opacity(0)
        } else {
            icon
                .iconSize(.small)
        }
    }

    @ViewBuilder private var badgeBackground: some View {
        if icon.isEmpty == false {
            backgroundColor
                .clipShape(Circle())
        }
    }
    
    var isEmpty: Bool {
        label.isEmpty && icon.isEmpty
    }

    private var iconColor: Color {
        switch type {
            case .neutral:                              return .inkNormal
            case .status(let status):                   return (status ?? defaultStatus).color
            case .custom(let iconColor, _):             return iconColor
        }
    }

    private var backgroundColor: Color {
        switch type {
            case .neutral:                              return .cloudLight
            case .status(let status):                   return (status ?? defaultStatus).lightColor
            case .custom(_, let backgroundColor):       return backgroundColor
        }
    }

    private var defaultStatus: Status {
        status ?? .info
    }
    
    /// Creates Orbit ``BadgeList`` component with custom content.
    public init(
        type: BadgeListType = .neutral,
        @ViewBuilder label: () -> Label,
        @ViewBuilder icon: () -> Icon
    ) {
        self.type = type
        self.icon = icon()
        self.label = label()
    }
}

// MARK: - Convenience Inits
public extension BadgeList where Icon == Orbit.Icon, Label == Text {

    /// Creates Orbit ``BadgeList`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        type: BadgeListType = .neutral
    ) {
        self.init(type: type) {
            Text(label)
        } icon: {
            Icon(icon)
        }
    }
    
    /// Creates Orbit ``BadgeList`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        type: BadgeListType = .neutral,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.init(type: type) {
            Text(label, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        }
    }
}

// MARK: - Types

/// A type of Orbit ``BadgeList``.
public enum BadgeListType: Equatable, Hashable, Sendable {
    case neutral
    case status(_ status: Status?)
    // FIXME: Remove and use override modifiers
    case custom(iconColor: Color, backgroundColor: Color)
    
    /// An Orbit ``BadgeListType`` `status` type with no value provided.
    public static var status: Self {
        .status(nil)
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
        VStack {
            BadgeList("Neutral BadgeList", icon: .grid)
            
            // EmptyView
            Group {
                BadgeList()
                BadgeList("")
                
                BadgeList {
                    Text("")
                } icon: {
                    Icon(nil)
                }
            }
            .border(.redNormal)
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
            BadgeList(type: .status(.info)) {
                Text("This is simple <ref>BadgeList</ref> item with <strong>SF Symbol</strong>")
            } icon: {
                Icon("info.circle.fill")
            }
            
            BadgeList(type: .status(.critical)) {
                Text("This is simple <ref>BadgeList</ref> item with <strong>CountryFlag</strong>")
            } icon: {
                CountryFlag("us")                
            }
            
            BadgeList("This is <ref>BadgeList</ref> item with no icon and custom color")
                .textColor(.blueDark)
            
            BadgeList(type: .status(nil)) {
                Text("This is a <ref>BadgeList</ref> with <strong>status</strong> override")
            } icon: {
                Icon("info.circle.fill")                
            }
        }
        .iconSize(.small)
        .status(.success)
        .padding(.medium)
        .previewDisplayName()
    }
}

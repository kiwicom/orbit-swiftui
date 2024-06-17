import SwiftUI

/// Orbit component that displays non-actionable, short and static information in a circular badge.
///
/// A ``NotificationBadge`` consists of a short label or icon.
///
/// ```swift
/// NotificationBadge("1", type: .lightInverted)
/// ```
///
/// ### Customizing appearance
///
/// The label and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
///
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
///
/// When type is set to ``BadgeType/status(_:inverted:)`` with a `nil` value, the default ``Status/info`` status can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// NotificationBadge(.user, type: .status(nil))
///     .status(.warning)
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/information/notificationbadge/)
public struct NotificationBadge<Content: View>: View {

    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.status) private var status
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor

    @ViewBuilder private let content: Content
    private let type: BadgeType

    public var body: some View {
        if isEmpty == false {
            content
                .textLinkColor(.custom(resolvedTextColor))
                .frame(minWidth: minWidth)
                .padding(.xxSmall) // = 24 height @ normal size
                .textColor(resolvedTextColor)
                .background(
                    resolvedBackground
                        .clipShape(Circle())
                )
                .fixedSize()
        }
    }


    @ViewBuilder private var resolvedBackground: some View {
        if let backgroundShape {
            backgroundShape.inactiveView
        } else {
            defaultBackgroundColor
        }
    }
    
    @ViewBuilder private var background: some View {
        switch type {
            case .light:                                Color.whiteDarker
            case .lightInverted:                        Color.inkDark
            case .neutral:                              Color.cloudLight
            case .status(let status, true):             (status ?? defaultStatus).color
            case .status(let status, false):            (status ?? defaultStatus).lightColor
        }
    }
    
    private var defaultBackgroundColor: Color {
        switch type {
            case .light:                                return .whiteDarker
            case .lightInverted:                        return .inkDark
            case .neutral:                              return .cloudLight
            case .status(let status, true):             return (status ?? defaultStatus).color
            case .status(let status, false):            return (status ?? defaultStatus).lightColor
        }
    }

    private var resolvedTextColor: Color {
        textColor ?? labelColor
    }

    private var labelColor: Color {
        switch type {
            case .light:                                return .inkDark
            case .lightInverted:                        return .whiteNormal
            case .neutral:                              return .inkDark
            case .status(let status, false):            return (status ?? defaultStatus).darkColor
            case .status(_, true):                      return .whiteNormal
        }
    }

    private var minWidth: CGFloat {
        Text.Size.small.lineHeight * sizeCategory.ratio
    }

    private var defaultStatus: Status {
        status ?? .info
    }
    
    /// Creates Orbit ``NotificationBadge`` component with custom content.
    public init(
        type: BadgeType = .status(nil),
        @ViewBuilder content: () -> Content
    ) {
        self.type = type
        self.content = content()
    }
}

// MARK: - Convenience Inits
public extension NotificationBadge {
    
    /// Creates Orbit ``NotificationBadge`` component containing text.
    init(
        _ label: some StringProtocol,
        type: BadgeType = .status(nil)
    ) where Content == Text {
        self.init(type: type) {
            Text(label)
                .textSize(.small)
                .fontWeight(.medium)
        }
    }

    /// Creates Orbit ``NotificationBadge`` component containing icon.
    init(
        _ icon: Icon.Symbol,
        type: BadgeType = .status(nil)
    ) where Content == Icon {
        self.init(type: type) {
            Icon(icon)
                .iconSize(.small)
        }
    }
}

// MARK: - Types
private extension NotificationBadge {

    enum Content {
        case icon(Icon.Symbol)
        case text(String)
    }
}

// MARK: - Previews
struct NotificationBadgePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            styles
            gradients
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            NotificationBadge("9")
            NotificationBadge("")  // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        NotificationBadge("88", type: .neutral)
            .measured()
            .padding(.medium)
            .previewDisplayName()
    }

    static var styles: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                badges(.light)
                badges(.lightInverted)
            }

            badges(.neutral)

            statusBadges(.info)
            statusBadges(.success)
            statusBadges(.warning)
            statusBadges(.critical)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var gradients: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            gradientBadge(.bundleBasic)
            gradientBadge(.bundleMedium)
            gradientBadge(.bundleTop)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                NotificationBadge(.airplane)
                    .iconColor(.pink)
                    .textColor(.blueDark)
                    .backgroundStyle(.whiteNormal)

                NotificationBadge {
                    CountryFlag("us")
                }
                NotificationBadge {
                    Icon("ant.fill")
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func badges(_ type: BadgeType) -> some View {
        HStack(spacing: .medium) {
            NotificationBadge(.grid, type: type)
            NotificationBadge("1", type: type)
        }
    }

    static func statusBadges(_ status: Status) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            badges(.status(status))
            badges(.status(status, inverted: true))
        }
        .previewDisplayName("\(String(describing: status).titleCased)")
    }

    static func gradientBadge(_ gradient: Gradient) -> some View {
        badges(.neutral)
            .backgroundStyle(gradient.background)
            .textColor(.whiteNormal)
            .previewDisplayName("\(String(describing: gradient).titleCased)")
    }
}

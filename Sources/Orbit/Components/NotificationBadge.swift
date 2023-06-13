import SwiftUI

/// Shows simple, non-interactive information in a circular badge.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/notificationbadge/)
public struct NotificationBadge<Content: View>: View {

    @Environment(\.status) private var status
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor

    private let style: BadgeStyle
    @ViewBuilder private let content: Content

    public var body: some View {
        if isEmpty == false {
            content
                .textLinkColor(.custom(resolvedTextColor))
                .frame(minWidth: minWidth)
                .padding(.xxSmall) // = 24 height @ normal size
                .textColor(resolvedTextColor)
                .background(
                    background
                        .clipShape(Circle())
                )
                .fixedSize()
        }
    }

    @ViewBuilder var background: some View {
        switch style {
            case .light:                                Color.whiteDarker
            case .lightInverted:                        Color.inkDark
            case .neutral:                              Color.cloudLight
            case .status(let status, true):             (status ?? defaultStatus).color
            case .status(let status, false):            (status ?? defaultStatus).lightColor
            case .custom(_, _, let backgroundColor):    backgroundColor
            case .gradient(let gradient):               gradient.background
        }
    }

    var resolvedTextColor: Color {
        textColor ?? labelColor
    }

    var labelColor: Color {
        switch style {
            case .light:                                return .inkDark
            case .lightInverted:                        return .whiteNormal
            case .neutral:                              return .inkDark
            case .status(let status, false):            return (status ?? defaultStatus).darkColor
            case .status(_, true):                      return .whiteNormal
            case .custom(let labelColor, _, _):         return labelColor
            case .gradient:                             return .whiteNormal
        }
    }

    var minWidth: CGFloat {
        Text.Size.small.lineHeight * sizeCategory.ratio
    }

    var defaultStatus: Status {
        status ?? .info
    }

    /// Creates Orbit NotificationBadge component with custom content.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    public init(
        style: BadgeStyle = .status(nil),
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
    }
}

// MARK: - Inits
public extension NotificationBadge {

    /// Creates Orbit NotificationBadge component containing text.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String,
        style: BadgeStyle = .status(nil)
    ) where Content == Text {
        self.init(style: style) {
            Text(label, size: .small)
                .fontWeight(.medium)
        }
    }

    /// Creates Orbit NotificationBadge component containing icon.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ icon: Icon.Symbol,
        style: BadgeStyle = .status(nil)
    ) where Content == Icon {
        self.init(style: style) {
            Icon(icon, size: .small)
        }
    }
}

// MARK: - Types
public extension NotificationBadge {

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
        NotificationBadge("88", style: .neutral)
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
                NotificationBadge(
                    .airplane,
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )
                .iconColor(.pink)

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

    static func badges(_ style: BadgeStyle) -> some View {
        HStack(spacing: .medium) {
            NotificationBadge(.grid, style: style)
            NotificationBadge("1", style: style)
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
        badges(.gradient(gradient))
            .previewDisplayName("\(String(describing: gradient).titleCased)")
    }
}

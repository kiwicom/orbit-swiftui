import SwiftUI

/// Shows simple, non-interactive information in a circular badge.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/notificationbadge/)
public struct NotificationBadge: View {

    @Environment(\.status) private var status
    @Environment(\.sizeCategory) private var sizeCategory

    let content: Content
    let style: Badge.Style

    public var body: some View {
        if isEmpty == false {
            contentView
                .padding(.xxSmall) // = 24 height @ normal size
                .foregroundColor(labelColor)
                .background(
                    background
                        .clipShape(Circle())
                )
                .fixedSize()
        }
    }

    @ViewBuilder var contentView: some View {
        switch content {
            case .text(let text):
                Text(text, size: .small)
                    .foregroundColor(nil)
                    .fontWeight(.medium)
                    .textLinkColor(.custom(labelColor))
                    .frame(minWidth: minTextWidth)
            case .icon(let icon):
                Icon(content: icon, size: .small)
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

    var minTextWidth: CGFloat {
        Text.Size.small.lineHeight * sizeCategory.ratio
    }

    var isEmpty: Bool {
        switch content {
            case .text(let text):   return text.isEmpty
            case .icon(let icon):   return icon.isEmpty
        }
    }

    var defaultStatus: Status {
        status ?? .info
    }
}

// MARK: - Inits
public extension NotificationBadge {
    
    /// Creates Orbit NotificationBadge component containing text.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(_ label: String, style: Badge.Style = .status(nil)) {
        self.init(content: .text(label), style: style)
    }

    /// Creates Orbit NotificationBadge component containing an icon.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(_ icon: Icon.Content, style: Badge.Style = .status(nil)) {
        self.init(content: .icon(icon), style: style)
    }
}

// MARK: - Types
public extension NotificationBadge {

    enum Content {
        case icon(Icon.Content)
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
                    .symbol(.airplane, color: .pink),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )

                NotificationBadge(.countryFlag("us"))
            }

            HStack(spacing: .small) {
                NotificationBadge(.image(.orbit(.facebook)))
                NotificationBadge(.sfSymbol("ant.fill"))
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func badges(_ style: Badge.Style) -> some View {
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

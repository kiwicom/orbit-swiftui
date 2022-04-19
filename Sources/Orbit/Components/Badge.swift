import SwiftUI

/// Presents users with short, relevant information.
///
/// Badges are indicators of static information.
/// They can be updated when a status changes, but they should not be actionable.
///
/// - Related components:
///   - ``NotificationBadge``
///   - ``Tag``
///   - ``Alert``
///   - ``Button``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/badge/)
public struct Badge: View {

    let label: String
    let iconContent: Icon.Content
    var style: Style
    let size: Size

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: size.spacing) {
                Icon(iconContent, size: .small)
                
                Text(
                    label,
                    size: .small,
                    color: .custom(style.labelColor),
                    weight: .medium,
                    linkColor: style.labelColor
                )
                .lineLimit(1)
            }
            .padding(.horizontal, size.padding)
            .frame(minWidth: size.height)
            .frame(height: size.height)
            .background(
                style.background
                    .clipShape(Capsule())
            )
            .overlay(
                Capsule()
                    .strokeBorder(style.outlineColor, lineWidth: BorderWidth.thin)
            )
            .fixedSize()
        }
    }
    
    var isEmpty: Bool {
        iconContent.isEmpty && label.isEmpty
    }
}

// MARK: - Inits
public extension Badge {
    
    /// Creates Orbit Badge component.
    init(_ label: String = "", iconContent: Icon.Content = .none, style: Style = .neutral, size: Size = .default) {
        self.label = label
        self.iconContent = iconContent
        self.style = style
        self.size = size
    }
    
    /// Creates Orbit Badge component with icon symbol.
    init(_ label: String = "", icon: Icon.Symbol = .none, style: Style = .neutral, size: Size = .default) {
        self.init(
            label,
            iconContent: .icon(icon, color: Color(style.labelColor)),
            style: style,
            size: size
        )
    }
    
    /// Creates Orbit Badge component with no icon.
    init(_ label: String = "", style: Style = .neutral, size: Size = .default) {
        self.init(label, iconContent: .none, style: style, size: size)
    }
}

// MARK: - Types
public extension Badge {

    enum Size {
        case `default`
        /// Compact size suitable for usage inside ``Tile``.
        case compact

        public var height: CGFloat {
            switch self {
                case .default:      return .large
                case .compact:      return 18
            }
        }

        public var padding: CGFloat {
            switch self {
                case .default:      return .xSmall
                case .compact:      return 6
            }
        }

        public var spacing: CGFloat {
            switch self {
                case .default:      return 5
                case .compact:      return 3
            }
        }
    }

    enum Style {

        case light
        case lightInverted
        case neutral
        case status(_ status: Status, inverted: Bool = false)
        case custom(labelColor: UIColor, outlineColor: SwiftUI.Color, backgroundColor: SwiftUI.Color)
        case gradient(Gradient)

        public var outlineColor: Color {
            switch self {
                case .light:                                return .cloudDark
                case .lightInverted:                        return .inkNormal
                case .neutral:                              return .cloudDark
                case .status(.info, false):                 return .blueLightHover
                case .status(.info, true):                  return .blueNormal
                case .status(.success, false):              return .greenLightHover
                case .status(.success, true):               return .greenNormal
                case .status(.warning, false):              return .orangeLightHover
                case .status(.warning, true):               return .orangeNormal
                case .status(.critical, false):             return .redLightHover
                case .status(.critical, true):              return .redNormal
                case .custom(_, let outlineColor, _):       return outlineColor
                case .gradient(let gradient):               return gradient.color
            }
        }

        @ViewBuilder public var background: some View {
            switch self {
                case .light:                                Color.white
                case .lightInverted:                        Color.inkNormal
                case .neutral:                              Color.cloudLight
                case .status(.info, false):                 Color.blueLight
                case .status(.info, true):                  Color.blueNormal
                case .status(.success, false):              Color.greenLight
                case .status(.success, true):               Color.greenNormal
                case .status(.warning, false):              Color.orangeLight
                case .status(.warning, true):               Color.orangeNormal
                case .status(.critical, false):             Color.redLight
                case .status(.critical, true):              Color.redNormal
                case .custom(_, _, let backgroundColor):    backgroundColor
                case .gradient(let gradient):               gradient.background
            }
        }

        public var labelColor: UIColor {
            switch self {
                case .light:                                return .inkNormal
                case .lightInverted:                        return .white
                case .neutral:                              return .inkNormal
                case .status(.info, false):                 return .blueDark
                case .status(.info, true):                  return .white
                case .status(.success, false):              return .greenDark
                case .status(.success, true):               return .white
                case .status(.warning, false):              return .orangeDark
                case .status(.warning, true):               return .white
                case .status(.critical, false):             return .redDark
                case .status(.critical, true):              return .white
                case .custom(let labelColor, _, _):         return labelColor
                case .gradient:                             return .white
            }
        }
    }
}

// MARK: - Previews
struct BadgePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
            storybookGradient
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Group {
            Badge("Label", icon: .grid)
            Badge()    // EmptyView
            Badge("")  // EmptyView
        }
        .padding(.medium)
    }

    static var storybook: some View {
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
    }

    static var storybookGradient: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            gradientBadge(.bundleBasic)
            gradientBadge(.bundleMedium)
            gradientBadge(.bundleTop)
        }
        .padding(.medium)
        .previewDisplayName("Gradient")
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                Badge(
                    "Custom",
                    iconContent: .icon(.airplane, color: .pink),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .white
                    )
                )

                Badge("Flag", iconContent: .countryFlag("us"))
            }

            HStack(spacing: .small) {
                Badge("Image", iconContent: .image(.orbit(.facebook)))
                Badge("SF Symbol", iconContent: .sfSymbol("applelogo"))
            }

            HStack {
                Badge("Compact", icon: .accommodation, style: .neutral, size: .compact)
                Badge("1", style: .status(.critical, inverted: true), size: .compact)
                Badge("", icon: .wifi, style: .neutral, size: .compact)
            }
        }
        .padding(.medium)
        .previewDisplayName("Mix")
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .medium) {
            Badge("label", style: style)
            Badge("label", icon: .grid, style: style)
            Badge(icon: .grid, style: style)
            Badge("1", style: style)
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

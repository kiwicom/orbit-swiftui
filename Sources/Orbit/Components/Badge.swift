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
        HStack(spacing: size.spacing) {
            iconContent.view()
            
            if label.isEmpty == false {
                Text(
                    label,
                    size: .small,
                    color: .custom(style.labelColor),
                    weight: .medium,
                    linkColor: style.labelColor
                )
                .lineLimit(1)
            }
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
            iconContent: .icon(icon, size: .small, color: Color(style.labelColor)),
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
                case .default:
                    return .large
                case .compact:
                    return 18
            }
        }

        public var padding: CGFloat {
            switch self {
                case .default:
                    return .xSmall
                case .compact:
                    return 6
            }
        }

        public var spacing: CGFloat {
            switch self {
                case .default:
                    return 5
                case .compact:
                    return 3
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
                case .light:                                return .cloudNormalHover
                case .lightInverted:                        return .inkNormal
                case .neutral:                              return .cloudLightHover
                case .status(.info, false):                 return .blueLightHover
                case .status(.info, true):                  return .blueNormal
                case .status(.success, false):              return .greenLightHover
                case .status(.success, true):               return .greenNormal
                case .status(.warning, false):              return .orangeLightHover
                case .status(.warning, true):               return .orangeNormal
                case .status(.critical, false):             return .redLightHover
                case .status(.critical, true):              return .redNormal
                case .custom(_, let outlineColor, _):       return outlineColor
                case .gradient(let gradient):               return gradient.outline
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
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var orbit: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .xxLarge) {
                VStack(alignment: .leading, spacing: .xSmall) {
                    Badge("Light", style: .light)
                    Badge("Light Inverted", style: .lightInverted)
                    Badge("Neutral", style: .neutral)
                }
                VStack(alignment: .leading, spacing: .xSmall) {
                    Badge("Info", style: .status(.info))
                    Badge("Info Inverted", style: .status(.info, inverted: true))
                    Badge("Success", style: .status(.success))
                    Badge("Success Inverted", style: .status(.success, inverted: true))
                    Badge("Warning", style: .status(.warning))
                    Badge("Warning Inverted", style: .status(.warning, inverted: true))
                    Badge("Critical", style: .status(.critical))
                    Badge("Critical Inverted", style: .status(.critical, inverted: true))
                }
                VStack(alignment: .leading, spacing: .xSmall) {
                    Badge("Orange Gradient", icon: .check, style: .gradient(.orange))
                    Badge("Purple Gradient", icon: .accomodation, style: .gradient(.purple))
                    Badge("Ink Gradient", icon: .airplaneUp, style: .gradient(.ink))
                }
            }

            VStack(alignment: .leading, spacing: .xxLarge) {
                VStack(alignment: .leading, spacing: .xSmall) {
                    Badge("Light", icon: .sun, style: .light)
                    Badge("Light Inverted", icon: .moon, style: .lightInverted)
                    Badge("Neutral", icon: .airplaneUp, style: .neutral)
                }
                VStack(alignment: .leading, spacing: .xSmall) {
                    Badge("Info", icon: .wifi, style: .status(.info))
                    Badge("Info Inverted", icon: .bus, style: .status(.info, inverted: true))
                    Badge("Success", icon: .airplane, style: .status(.success))
                    Badge("Success Inverted", icon: .baggageCabin, style: .status(.success, inverted: true))
                    Badge("Warning", icon: .baggageNone, style: .status(.warning))
                    Badge("Warning Inverted", icon: .accomodation, style: .status(.warning, inverted: true))
                    Badge("Critical", icon: .accomodation, style: .status(.critical))
                    Badge("Critical Inverted", icon: .accomodation, style: .status(.critical, inverted: true))
                }
                VStack(alignment: .leading, spacing: .xSmall) {
                    Badge("Orange Gradient", style: .gradient(.orange))
                    Badge("Purple Gradient", style: .gradient(.purple))
                    Badge("Ink Gradient", style: .gradient(.ink))
                }
            }
        }
    }

    static var standalone: some View {
        Badge("Label", icon: .informationCircle, style: .neutral)
    }

    static var snapshots: some View {
        Group {
            orbit
                .padding(.vertical)
                .previewDisplayName("Figma")

            HStack(spacing: .xxLarge) {
                Badge(
                    "Custom",
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .white
                    )
                )

                Badge(
                    "Custom",
                    iconContent: .icon(.airplane, size: .small, color: .pink),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .white
                    )
                )
            }
            .padding(.vertical)
            .previewDisplayName("Custom")

            HStack {
                Badge("Only label", style: .neutral)
                Badge("1", style: .status(.critical, inverted: true))
                Badge("", icon: .wifi, style: .neutral)
            }
            .padding(.vertical)
            .previewDisplayName("Only icon or label")

            HStack {
                Badge("Label", icon: .accomodation, style: .neutral, size: .compact)
                Badge("Only label", style: .neutral, size: .compact)
                Badge("1", style: .status(.critical, inverted: true), size: .compact)
                Badge("", icon: .wifi, style: .neutral, size: .compact)
            }
            .padding(.vertical)
            .previewDisplayName("Compact size")
        }
        .padding(.horizontal)
    }
}

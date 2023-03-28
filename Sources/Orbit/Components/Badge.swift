import SwiftUI

/// Presents users with short, relevant information.
///
/// Badges are indicators of static information.
/// They can be updated when a status changes, but they should not be actionable.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/badge/)
public struct Badge: View {

    @Environment(\.sizeCategory) var sizeCategory

    let label: String
    let iconContent: Icon.Content
    var style: Style

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: .xxSmall) {
                Icon(content: iconContent, size: .small)

                Text(
                    label,
                    size: .small,
                    color: nil,
                    weight: .medium
                )
                .textLinkColor(.custom(style.labelColor))
                .frame(minWidth: minTextWidth)
            }
            .foregroundColor(Color(style.labelColor))
            .padding(.vertical, .xxSmall) // = 24 height @ normal size
            .padding(.horizontal, .xSmall)
            .background(
                style.background
                    .clipShape(shape)
            )
            .overlay(
                shape
                    .strokeBorder(style.outlineColor, lineWidth: BorderWidth.thin)
            )
        }
    }

    var minTextWidth: CGFloat {
        Text.Size.small.lineHeight * sizeCategory.ratio - .xSmall
    }

    var shape: some InsettableShape {
        Capsule()
    }

    var isEmpty: Bool {
        iconContent.isEmpty && label.isEmpty
    }
}

// MARK: - Inits
public extension Badge {
    
    /// Creates Orbit Badge component.
    init(_ label: String = "", icon: Icon.Content = .none, style: Style = .neutral) {
        self.label = label
        self.iconContent = icon
        self.style = style
    }
}

// MARK: - Types
public extension Badge {

    enum Style {

        case light
        case lightInverted
        case neutral
        case status(_ status: Status, inverted: Bool = false)
        case custom(labelColor: UIColor, outlineColor: SwiftUI.Color, backgroundColor: SwiftUI.Color)
        case gradient(Gradient)

        public var outlineColor: Color {
            switch self {
                case .light:                                return .cloudNormal
                case .lightInverted:                        return .clear
                case .neutral:                              return .cloudNormal
                case .status(_, true):                      return .clear
                case .status(.info, false):                 return .blueLightHover
                case .status(.success, false):              return .greenLightHover
                case .status(.warning, false):              return .orangeLightHover
                case .status(.critical, false):             return .redLightHover
                case .custom(_, let outlineColor, _):       return outlineColor
                case .gradient:                             return .clear
            }
        }

        @ViewBuilder public var background: some View {
            switch self {
                case .light:                                Color.whiteDarker
                case .lightInverted:                        Color.inkDark
                case .neutral:                              Color.cloudLight
                case .status(let status, true):             status.color
                case .status(let status, false):            status.lightColor
                case .custom(_, _, let backgroundColor):    backgroundColor
                case .gradient(let gradient):               gradient.background
            }
        }

        public var labelColor: UIColor {
            switch self {
                case .light:                                return .inkDark
                case .lightInverted:                        return .whiteNormal
                case .neutral:                              return .inkDark
                case .status(let status, false):            return status.darkUIColor
                case .status(_, true):                      return .whiteNormal
                case .custom(let labelColor, _, _):         return labelColor
                case .gradient:                             return .whiteNormal
            }
        }
    }
}

// MARK: - Previews
struct BadgePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            statuses
            gradients
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            Badge("label", icon: .grid)
            Badge()    // EmptyView
            Badge("")  // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .trailing, spacing: .xSmall) {
            Group {
                Badge("Badge")
                Badge("Badge", icon: .grid)
                Badge(icon: .grid)
                Badge("Multiline\nBadge", icon: .grid)
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var statuses: some View {
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

            HStack(alignment: .top, spacing: .medium) {
                Badge("Very very very very very long badge")
                Badge("Very very very very very long badge")
            }
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
                Badge(
                    "Custom",
                    icon: .symbol(.airplane, color: .pink),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )

                Badge("Flag", icon: .countryFlag("us"))
                Badge("Flag", icon: .countryFlag("us"), style: .status(.critical, inverted: true))
            }

            HStack(spacing: .small) {
                Badge("Image", icon: .image(.orbit(.facebook)))
                Badge("Image", icon: .image(.orbit(.facebook)), style: .status(.success, inverted: true))
            }

            HStack(spacing: .small) {
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"))
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"), style: .status(.warning, inverted: true))
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .small) {
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

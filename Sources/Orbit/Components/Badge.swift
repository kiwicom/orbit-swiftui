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

    public static let verticalPadding: CGFloat = 4 + 1/3 // Makes height exactly 24 at normal text size
    public static let textSize: Text.Size = .small

    let label: String
    let iconContent: Icon.Content
    var style: Style

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: 0) {
                HStack(spacing: .xxSmall) {
                    Icon(iconContent, size: .small)

                    Text(
                        label,
                        size: Self.textSize,
                        color: .none,
                        weight: .medium,
                        linkColor: .custom(style.labelColor)
                    )
                    .padding(.vertical, Self.verticalPadding)
                }
                .foregroundColor(Color(style.labelColor))

                TextStrut(Self.textSize)
                    .padding(.vertical, Self.verticalPadding)
            }
            .padding(.horizontal, .xSmall)
            .frameWidthAtLeastHeight()
            .background(
                style.background
                    .clipShape(shape)
            )
            .overlay(
                shape
                    .strokeBorder(style.outlineColor, lineWidth: BorderWidth.thin)
            )
            .fixedSize()
        }
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
                case .light:                                return .cloudDark
                case .lightInverted:                        return .clear
                case .neutral:                              return .cloudDark
                case .status(.info, false):                 return .blueLightHover
                case .status(.info, true):                  return .clear
                case .status(.success, false):              return .greenLightHover
                case .status(.success, true):               return .clear
                case .status(.warning, false):              return .orangeLightHover
                case .status(.warning, true):               return .clear
                case .status(.critical, false):             return .redLightHover
                case .status(.critical, true):              return .clear
                case .custom(_, let outlineColor, _):       return outlineColor
                case .gradient:                             return .clear
            }
        }

        @ViewBuilder public var background: some View {
            switch self {
                case .light:                                Color.whiteNormal
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
                case .lightInverted:                        return .whiteNormal
                case .neutral:                              return .inkNormal
                case .status(.info, false):                 return .blueDark
                case .status(.info, true):                  return .whiteNormal
                case .status(.success, false):              return .greenDark
                case .status(.success, true):               return .whiteNormal
                case .status(.warning, false):              return .orangeDark
                case .status(.warning, true):               return .whiteNormal
                case .status(.critical, false):             return .redDark
                case .status(.critical, true):              return .whiteNormal
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
            storybook
            storybookGradient
            storybookMix
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
    }

    static var sizing: some View {
        VStack(spacing: .xSmall) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Badge height \(state.wrappedValue)")
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Badge height \(state.wrappedValue)", icon: .grid)
                }
            }
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
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"))
                Badge("SF Symbol", icon: .sfSymbol("info.circle.fill"), style: .status(.warning, inverted: true))
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

struct BadgeDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        BadgePreviews.standalone
        BadgePreviews.sizing
        Badge("1")
    }
}

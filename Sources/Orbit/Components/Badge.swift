import SwiftUI

/// Presents users with short, relevant information.
///
/// Badges are indicators of static information.
/// They can be updated when a status changes, but they should not be actionable.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/badge/)
public struct Badge: View {

    public static let verticalPadding: CGFloat = .xxSmall   // Results in ±24 height at normal text size
    public static let textSize: Text.Size = .small

    let label: String
    let iconContent: Icon.Content
    var style: Style

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: 0) {
                HStack(spacing: .xxSmall) {
                    Icon(content: iconContent, size: .small)

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
                case .light:                                Color.whiteDarker
                case .lightInverted:                        Color.inkDark
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
                case .light:                                return .inkDark
                case .lightInverted:                        return .whiteNormal
                case .neutral:                              return .inkDark
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
            
            statuses
            gradients
            mix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            Badge("label", icon: .grid)
            Badge()    // EmptyView
            Badge("")  // EmptyView
        }
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .xSmall) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Height \(state.wrappedValue.rounded())")
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Height \(state.wrappedValue.rounded())", icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Badge("Multiline text\nheight \(state.wrappedValue.rounded())", icon: .grid)
                }
            }
        }
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
        .previewDisplayName()
    }

    static var gradients: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            gradientBadge(.bundleBasic)
            gradientBadge(.bundleMedium)
            gradientBadge(.bundleTop)
        }
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
        .previewDisplayName()
    }

    static var snapshot: some View {
        statuses
            .padding(.medium)
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

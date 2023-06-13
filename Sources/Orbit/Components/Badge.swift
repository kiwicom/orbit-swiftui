import SwiftUI

/// Presents users with short, relevant information.
///
/// Badges are indicators of static information.
/// They can be updated when a status changes, but they should not be actionable.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/badge/)
public struct Badge: View {

    @Environment(\.status) private var status
    @Environment(\.sizeCategory) private var sizeCategory

    let label: String
    let leadingIcon: Icon.Content?
    let trailingIcon: Icon.Content?
    var style: Style

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: .xxSmall) {
                Icon(leadingIcon, size: .small)
                    .fontWeight(.medium)

                Text(label, size: .small)
                    .fontWeight(.medium)
                    .textLinkColor(.custom(labelColor))
                    .frame(minWidth: minTextWidth)

                Icon(trailingIcon, size: .small)
                    .fontWeight(.medium)
            }
            .textColor(labelColor)
            .padding(.vertical, .xxSmall) // = 24 height @ normal size
            .padding(.horizontal, .xSmall)
            .background(
                background
                    .clipShape(Capsule())
            )
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

    var minTextWidth: CGFloat {
        Text.Size.small.lineHeight * sizeCategory.ratio - .xSmall
    }

    var isEmpty: Bool {
        isLeadingIconEmpty && label.isEmpty && isTrailingIconEmpty
    }

    var isLeadingIconEmpty: Bool {
        leadingIcon?.isEmpty ?? true
    }

    var isTrailingIconEmpty: Bool {
        trailingIcon?.isEmpty ?? true
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

    var defaultStatus: Status {
        status ?? .info
    }
}

// MARK: - Inits
public extension Badge {
    
    /// Creates Orbit Badge component.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String = "",
        leadingIcon: Icon.Content? = nil,
        trailingIcon: Icon.Content? = nil,
        style: Style = .neutral
    ) {
        self.label = label
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.style = style
    }
}

// MARK: - Types
public extension Badge {

    enum Style {

        case light
        case lightInverted
        case neutral
        case status(_ status: Status? = nil, inverted: Bool = false)
        case custom(labelColor: Color, outlineColor: Color, backgroundColor: Color)
        case gradient(Gradient)

        public static var status: Self {
            .status(nil)
        }
    }
}

// MARK: - Previews
struct BadgePreviews: PreviewProvider {

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
            Badge("label", leadingIcon: .grid)
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
                Badge("Badge", leadingIcon: .grid)
                Badge("Badge", leadingIcon: .grid, trailingIcon: .grid)
                Badge(leadingIcon: .grid)
                Badge("Multiline\nBadge", leadingIcon: .grid)
            }
            .measured()
        }
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
                    leadingIcon: .symbol(.airplane, color: .pink),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )

                Badge("Flag", leadingIcon: .countryFlag("us"))
                Badge("Flag", leadingIcon: .countryFlag("us"), style: .status(.critical, inverted: true))
            }

            HStack(spacing: .small) {
                Badge("Image", leadingIcon: .image(.orbit(.facebook)))
                Badge("Image", leadingIcon: .image(.orbit(.facebook)), style: .status(.success, inverted: true))
            }

            HStack(spacing: .small) {
                Badge("SF Symbol", leadingIcon: .sfSymbol("info.circle.fill"))
                if #available(iOS 16.0, *) {
                    Badge("SF Symbol", leadingIcon: .sfSymbol("info.circle.fill"))
                        .fontWeight(.black)
                }
                Badge("SF Symbol", leadingIcon: .sfSymbol("info.circle.fill"), style: .status(.warning, inverted: true))
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .small) {
            Badge("label", style: style)
            Badge("label", leadingIcon: .grid, style: style)
            Badge(leadingIcon: .grid, style: style)
            Badge("label", trailingIcon: .grid, style: style)
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

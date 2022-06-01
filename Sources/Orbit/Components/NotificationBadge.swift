import SwiftUI

/// Shows simple, non-interactive information in a circular badge.
///
/// - Related components:
///   - ``Badge``
///   - ``Tag``
///   - ``Alert``
///   - ``Button``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/notificationbadge/)
public struct NotificationBadge: View {

    public static let horizontalPadding: CGFloat = 6
    public static let verticalPadding: CGFloat = 1 + 1/3
    public static let textSize: Text.Size = .small

    let label: String
    let iconContent: Icon.Content
    var style: Badge.Style

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: 0) {
                HStack(spacing: .xxxSmall) {
                    Icon(content: iconContent, size: .text(Self.textSize))
                    
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
            .padding(.horizontal, Self.horizontalPadding)
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
public extension NotificationBadge {
    
    /// Creates Orbit NotificationBadge component.
    init(_ label: String = "", icon: Icon.Content = .none, style: Badge.Style = .neutral) {
        self.label = label
        self.iconContent = icon
        self.style = style
    }
}

// MARK: - Previews
struct NotificationBadgePreviews: PreviewProvider {

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
            NotificationBadge("label", icon: .grid)
            NotificationBadge()    // EmptyView
            NotificationBadge("")  // EmptyView
        }
        .padding(.medium)
    }

    static var sizing: some View {
        StateWrapper(initialState: CGFloat(0)) { state in
            ContentHeightReader(height: state) {
                NotificationBadge("NotificationBadge height \(state.wrappedValue)")
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
                NotificationBadge(
                    "Custom",
                    icon: .symbol(.airplane, color: .pink),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )

                NotificationBadge("Flag", icon: .countryFlag("us"))
            }

            HStack(spacing: .small) {
                NotificationBadge("Image", icon: .image(.orbit(.facebook)))
                NotificationBadge("SF Symbol", icon: .sfSymbol("info.circle.fill"))
            }
        }
        .padding(.medium)
        .previewDisplayName("Mix")
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .medium) {
            NotificationBadge("label", style: style)
            NotificationBadge("label", icon: .grid, style: style)
            NotificationBadge(icon: .grid, style: style)
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

struct NotificationBadgeDynamicTypePreviews: PreviewProvider {

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
        NotificationBadgePreviews.standalone
        NotificationBadge("1")
    }
}

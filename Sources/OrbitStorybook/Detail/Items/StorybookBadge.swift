import SwiftUI
import Orbit

struct StorybookBadge {

    static var basic: some View {
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

    static var gradient: some View {
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
                Badge("SF Symbol", leadingIcon: .sfSymbol("info.circle.fill"), style: .status(.warning, inverted: true))
            }
        }
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
    }

    static func gradientBadge(_ gradient: Orbit.Gradient) -> some View {
        badges(.gradient(gradient))
    }
}

struct StorybookBadgePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookBadge.basic
            StorybookBadge.gradient
            StorybookBadge.mix
        }
    }
}

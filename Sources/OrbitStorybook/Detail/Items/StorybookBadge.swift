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
    }

    static var gradient: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            gradientBadge(.bundleBasic)
            gradientBadge(.bundleMedium)
            gradientBadge(.bundleTop)
        }
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

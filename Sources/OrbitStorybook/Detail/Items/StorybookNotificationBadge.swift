import SwiftUI
import Orbit

struct StorybookNotificationBadge {

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

    static func gradientBadge(_ gradient: Orbit.Gradient) -> some View {
        badges(.gradient(gradient))
            .previewDisplayName("\(String(describing: gradient).titleCased)")
    }
}

struct StorybookNotificationBadgePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookNotificationBadge.basic
            StorybookNotificationBadge.gradient
            StorybookNotificationBadge.mix
        }
    }
}

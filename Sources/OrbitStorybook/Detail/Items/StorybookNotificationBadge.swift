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
                NotificationBadge(.airplane)
                    .iconColor(.pink)
                    .textColor(.blueDark)
                    .backgroundStyle(.whiteNormal)

                NotificationBadge {
                    CountryFlag("us")
                }
                NotificationBadge {
                    Icon("ant.fill")
                }
            }
        }
        .previewDisplayName()
    }

    static func badges(_ type: BadgeType) -> some View {
        HStack(spacing: .medium) {
            NotificationBadge(.grid, type: type)
            NotificationBadge("1", type: type)
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
        badges(.neutral)
            .backgroundStyle(gradient.background)
            .textColor(.whiteNormal)
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

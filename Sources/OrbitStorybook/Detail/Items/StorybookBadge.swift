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
                Badge("Custom", icon: .airplane)
                    .iconColor(.pink)
                    .textColor(.blueDark)
                    .backgroundStyle(.whiteHover)

                Badge {
                    Text("Flag")
                } icon: {
                    CountryFlag("us")                    
                }
                
                Badge(type: .status(.critical, inverted: true)) {
                    Text("Flag")
                } icon: {
                    CountryFlag("cz")                    
                }
            }

            HStack(spacing: .small) {
                Badge(type: .status(.success)) {
                    Text("SF Symbol")
                } icon: {
                    Icon("info.circle.fill")                    
                }
                
                Badge(type: .status(.warning, inverted: true)) {
                    Text("SF Symbol")
                } icon: {
                    Image(systemName: "info.circle.fill")                    
                }
            }
        }
        .previewDisplayName()
    }

    static func badges(_ type: BadgeType) -> some View {
        HStack(spacing: .small) {
            Badge("label", type: type)
            Badge("label", icon: .grid, type: type)
            Badge(icon: .grid, type: type)
            Badge("1", type: type)
        }
    }

    static func statusBadges(_ status: Status) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            badges(.status(status))
            badges(.status(status, inverted: true))
        }
    }

    static func gradientBadge(_ gradient: Orbit.Gradient) -> some View {
        badges(.neutral)
            .textColor(.whiteNormal)
            .backgroundStyle(gradient.background)
            .previewDisplayName("\(String(describing: gradient).titleCased)")
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

import SwiftUI
import Orbit

struct StorybookButton {

    @ViewBuilder static var basic: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .previewDisplayName()
    }

    @ViewBuilder static var status: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }
        .previewDisplayName()
    }

    @ViewBuilder static var gradient: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.gradient(.bundleBasic))
            buttons(.gradient(.bundleMedium))
            buttons(.gradient(.bundleTop))
        }
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button("Button with SF Symbol", icon: .sfSymbol("info.circle.fill"), action: {})
            Button("Button with Flag", icon: .countryFlag("cz"), action: {})
            Button("Button with Image", icon: .image(.orbit(.facebook)), action: {})
        }
        .previewDisplayName()
    }

    @ViewBuilder static func buttons(_ style: Orbit.Button.Style) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", style: style, action: {})
                Button("Label", icon: .grid, style: style, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronRight, style: style, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronRight, style: style, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", style: style, action: {})
                    .idealSize()
                Button(.grid, style: style, action: {})
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", style: style, size: .small, action: {})
                    .idealSize()
                Button(.grid, style: style, size: .small, action: {})
                Spacer()
            }
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, subtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ style: Orbit.Button.Style) -> some View {
        HStack(spacing: .xSmall) {
            Group {
                Button("Label", style: style, size: .small, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronRight, style: style, size: .small, action: {})
                Button("Label", disclosureIcon: .chevronRight, style: style, size: .small, action: {})
                Button(.grid, style: style, size: .small, action: {})
            }
            .idealSize()

            Spacer(minLength: 0)
        }
    }
}

struct StorybookButtonPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookButton.basic
            StorybookButton.status
            StorybookButton.gradient
            StorybookButton.mix
        }
    }
}

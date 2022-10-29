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
    }

    @ViewBuilder static var status: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }
    }

    @ViewBuilder static var gradient: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.gradient(.bundleBasic))
            buttons(.gradient(.bundleMedium))
            buttons(.gradient(.bundleTop))
        }
    }

    @ViewBuilder static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button("Button with SF Symbol", icon: .sfSymbol("info.circle.fill"))
            Button("Button with Flag", icon: .countryFlag("cz"))
            Button("Button with Image", icon: .image(.orbit(.facebook)))
        }
    }

    @ViewBuilder static func buttons(_ style: Orbit.Button.Style) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", style: style)
                Button("Label", icon: .grid, style: style)
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronRight, style: style)
                Button("Label", icon: .grid, disclosureIcon: .chevronRight, style: style)
            }
            HStack(spacing: .small) {
                Button("Label", style: style)
                    .idealSize()
                Button(.grid, style: style)
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", style: style, size: .small)
                    .idealSize()
                Button(.grid, style: style, size: .small)
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
                Button("Label", style: style, size: .small)
                Button("Label", icon: .grid, disclosureIcon: .chevronRight, style: style, size: .small)
                Button("Label", disclosureIcon: .chevronRight, style: style, size: .small)
                Button(.grid, style: style, size: .small)
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

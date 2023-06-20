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
            Button("Button with SF Symbol") {
                // No action
            } icon: {
                Icon("info.circle.fill")
            }
            Button("Button with Flag") {
                // No action
            } icon: {
                CountryFlag("us")
            }
        }
        .previewDisplayName()
    }

    @ViewBuilder static func buttons(_ type: ButtonType) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                Button("Label", icon: .grid, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", type: type, size: .small, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, size: .small, action: {})
                Spacer()
            }
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, isSubtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ type: ButtonType) -> some View {
        HStack(spacing: .xSmall) {
            Group {
                Button("Label", type: type, size: .small, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, size: .small, action: {})
                Button("Label", disclosureIcon: .chevronForward, type: type, size: .small, action: {})
                Button(icon: .grid, type: type, size: .small, action: {})
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

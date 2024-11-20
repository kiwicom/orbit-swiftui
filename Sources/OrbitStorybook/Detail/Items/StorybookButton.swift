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
            buttons(.prominent)
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
            buttons(.primary)
                .backgroundStyle(Gradient.bundleBasic.background, active: Gradient.bundleBasic.startColor)
                .previewDisplayName("Bundle Basic")
            buttons(.primary)
                .backgroundStyle(Gradient.bundleMedium.background, active: Gradient.bundleMedium.startColor)
                .previewDisplayName("Bundle Medium")
            buttons(.primary)
                .backgroundStyle(Gradient.bundleTop.background, active: Gradient.bundleTop.startColor)
                .previewDisplayName("Bundle Top")
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button {
                // No action
            } label: {
              Text("Button with SF Symbol")  
            } icon: {
                Icon("info.circle.fill")
            }
            
            Button(type: .secondary) {
                // No action
            } label: {
                Text("Button with SF Symbol")  
            } icon: {
                CountryFlag("us")
            }
        }
        .padding(.medium)
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
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            .buttonSize(.compact)
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
                Button("Label", type: type, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
                Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
                Button(icon: .grid, type: type, action: {})
            }
            .buttonSize(.compact)
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

import SwiftUI
import Orbit

struct StorybookButtonLink {

    static var basic: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary)
                ButtonLink("ButtonLink Secondary", style: .secondary)
                ButtonLink("ButtonLink Critical", style: .critical)
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary, icon: .accommodation)
                ButtonLink("ButtonLink Secondary", style: .secondary, icon: .airplaneDown)
                ButtonLink("ButtonLink Critical", style: .critical, icon: .alertCircle)
            }
        }
    }

    static var status: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", style: .status(.info), icon: .informationCircle)
            ButtonLink("ButtonLink Success", style: .status(.success), icon: .checkCircle)
            ButtonLink("ButtonLink Warning", style: .status(.warning), icon: .alert)
            ButtonLink("ButtonLink Critical", style: .status(.critical), icon: .alertCircle)
        }
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("ButtonLink intrinsic size", icon: .baggageSet)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink small button size", icon: .baggageSet, size: .buttonSmall)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink button size", icon: .baggageSet, size: .button)
                .border(Color.cloudNormal)
        }
    }
}

struct StorybookButtonLinkPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookButtonLink.basic
            StorybookButtonLink.status
            StorybookButtonLink.sizes
        }
    }
}

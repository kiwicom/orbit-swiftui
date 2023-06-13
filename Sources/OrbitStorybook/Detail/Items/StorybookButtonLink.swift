import SwiftUI
import Orbit

struct StorybookButtonLink {

    static var basic: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", type: .primary, action: {})
                ButtonLink("ButtonLink Secondary", type: .secondary, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, action: {})
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", type: .primary, icon: .accommodation, action: {})
                ButtonLink("ButtonLink Secondary", type: .secondary, icon: .airplaneDown, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, icon: .alertCircle, action: {})
            }
        }
        .previewDisplayName()
    }

    static var status: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", type: .status(.info), icon: .informationCircle, action: {})
            ButtonLink("ButtonLink Success", type: .status(.success), icon: .checkCircle, action: {})
            ButtonLink("ButtonLink Warning", type: .status(.warning), icon: .alert, action: {})
            ButtonLink("ButtonLink Critical", type: .status(.critical), icon: .alertCircle, action: {})
        }
        .previewDisplayName()
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("ButtonLink intrinsic size", icon: .baggageSet, action: {})
                .border(.cloudNormal)
            ButtonLink("ButtonLink small button size", icon: .baggageSet, size: .buttonSmall, action: {})
                .border(.cloudNormal)
            ButtonLink("ButtonLink button size", icon: .baggageSet, size: .button, action: {})
                .border(.cloudNormal)
        }
        .previewDisplayName()
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

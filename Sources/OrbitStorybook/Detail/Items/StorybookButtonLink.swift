import SwiftUI
import Orbit

struct StorybookButtonLink {

    static var basic: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", type: .primary, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, action: {})
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", icon: .accommodation, type: .primary, action: {})
                ButtonLink("ButtonLink Critical", icon: .alertCircle, type: .critical, action: {})
            }
        }
        .buttonSize(.compact)
        .previewDisplayName()
    }

    static var status: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", icon: .informationCircle, type: .status(.info), action: {})
            ButtonLink("ButtonLink Success", icon: .checkCircle, type: .status(.success), action: {})
            ButtonLink("ButtonLink Warning", icon: .alert, type: .status(.warning), action: {})
            ButtonLink("ButtonLink Critical", icon: .alertCircle, type: .status(.critical), action: {})
        }
        .buttonSize(.compact)
        .previewDisplayName()
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("ButtonLink intrinsic size", icon: .baggageSet, action: {})
                .buttonSize(.compact)
                .border(.cloudNormal)
            ButtonLink("ButtonLink button size", icon: .baggageSet, action: {})
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

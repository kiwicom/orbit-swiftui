import SwiftUI
import Orbit

struct StorybookDialog {

    static let title1 = "Kiwi.com would like to send you notifications."
    static let title2 = "Do you really want to delete your account?"

    static let description1 = "Notifications may include alerts, sounds, and icon badges."
        + "These can be configured in Settings"
    static let description2 = "This action is irreversible, once you delete your account, it's gone."
        + " It will not affect any bookings in progress."

    static var basic: some View {
        VStack(spacing: 0) {
            normal
            centered
            critical
            titleOnly
            descriptionOnly
        }
    }

    static var normal: some View {
        Dialog(
            illustration: .noNotification,
            title: title1,
            description: description1,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        )
    }

    static var centered: some View {
        Dialog(
            illustration: .noNotification,
            title: title1,
            description: description1,
            alignment: .center,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        )
        .background(Color.whiteNormal)
    }

    static var critical: some View {
        Dialog(
            illustration: .noNotification,
            title: title2,
            description: description2,
            style: .critical,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        )
    }

    static var titleOnly: some View {
        Dialog(
            title: title1,
            buttons: .primaryAndSecondary("Main CTA", "Secondary")
        )
    }

    static var descriptionOnly: some View {
        Dialog(
            description: description1,
            buttons: .primary("Main CTA")
        )
    }
}

struct StorybookDialogPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookDialog.basic
        }
    }
}

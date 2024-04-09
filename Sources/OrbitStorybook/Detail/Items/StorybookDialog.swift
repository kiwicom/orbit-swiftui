import SwiftUI
import Orbit

struct StorybookDialog {

    static let title1 = "Kiwi.com would like to send you notifications."
    static let title2 = "Do you really want to delete your account?"

    static let description1 = "Notifications may include alerts, sounds, and icon badges."
        + "These can be configured in <applink1>Settings</applink1>"
    static let description2 = "This action is irreversible, once you delete your account, it's gone."
        + " It will not affect any bookings in progress."

    static var basic: some View {
        VStack(spacing: 0) {
            normal
            critical
            titleOnly
            descriptionOnly
        }
        .previewDisplayName()
    }

    static var normal: some View {
        Dialog(
            title1,
            description: description1,
            illustration: .noNotification
        ) {
            Button("Main CTA") {}
            Button("Secondary") {}
            Button("Tertiary") {}
        }
    }

    static var critical: some View {
        Dialog(
            title2,
            description: description2,
            illustration: .noNotification
        ) {
            Button("Main CTA") {}
            Button("Secondary") {}
            Button("Tertiary") {}
        }
        .status(.critical)
    }

    static var titleOnly: some View {
        Dialog(title1) {
            Button("Main CTA") {}
            Button("Secondary") {}
        }
    }

    static var descriptionOnly: some View {
        Dialog(description: description1) {
            Button("Main CTA") {}
        }
    }
}

struct StorybookDialogPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookDialog.basic
            StorybookDialog.normal
        }
    }
}

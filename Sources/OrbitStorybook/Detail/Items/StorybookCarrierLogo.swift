import SwiftUI
import Orbit

struct StorybookCarrierLogo {

    static let square = Image(systemName: "square.fill")
    static let plane = Image(systemName: "airplane.circle.fill")

    static var basic: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            carrierLogoContent
        }
    }

    @ViewBuilder static var carrierLogoContent: some View {
        HStack(alignment: .top, spacing: .medium) {
            CarrierLogo(image: square, size: .small)
            CarrierLogo(image: square, size: .normal)
            CarrierLogo(image: square, size: .large)
        }

        HStack(alignment: .top, spacing: .medium) {
            CarrierLogo(image: plane, size: .small)
            CarrierLogo(image: plane, size: .normal)
            CarrierLogo(image: plane, size: .large)
        }

        CarrierLogo(images: [square, square])

        CarrierLogo(images: [square, square, square])

        CarrierLogo(images: [square, square, square, square])
    }
}

struct StorybookCarrierLogoPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCarrierLogo.basic
        }
    }
}

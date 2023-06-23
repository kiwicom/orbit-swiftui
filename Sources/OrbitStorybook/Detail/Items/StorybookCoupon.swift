import SwiftUI
import Orbit

struct StorybookCoupon {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Coupon("COUPONCODE")

            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                Coupon("HXT3B81F")
                    .textColor(.blueDark)
                    .previewDisplayName()

                Text("PROMOCODE")
            }
            .textSize(.small)
        }
        .previewDisplayName()
    }
}

struct StorybookCouponPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCoupon.basic
        }
    }
}

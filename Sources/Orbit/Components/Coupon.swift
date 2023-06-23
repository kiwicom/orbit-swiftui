import SwiftUI

/// Orbit component that highlights promo codes.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/visuals/coupon/)
public struct Coupon: View {

    let label: String

    public var body: some View {
        Text(label)
            .fontWeight(.medium)
            .kerning(0.75)
            .textIsCopyable()
            .padding(.horizontal, .xxSmall)
            .padding(.vertical, .xxxSmall)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.desktop)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .foregroundColor(.cloudDark)
            )
    }
}

// MARK: - Inits
public extension Coupon {
    
    /// Creates Orbit Coupon component.
    init(_ label: String = "") {
        self.label = label
    }
}

// MARK: - Previews
struct CouponPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            Coupon("COUPONCODE")
            Coupon()    // EmptyView
            Coupon("")  // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Coupon("HXT3B81F")
                .textColor(.blueDark)
                .previewDisplayName()

            Text("PROMOCODE")
        }
        .textSize(.small)
        .padding(.medium)
    }
}

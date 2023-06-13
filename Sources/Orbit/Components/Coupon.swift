import SwiftUI

/// Orbit component that highlights promo codes.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/visuals/coupon/)
public struct Coupon: View {

    let label: String
    let size: Text.Size

    public var body: some View {
        Text(label, size: size, isSelectable: true)
            .fontWeight(.medium)
            .kerning(0.75)
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
    init(_ label: String = "", size: Text.Size = .normal) {
        self.label = label
        self.size = size
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
            Coupon("HXT3B81F", size: .small)
                .textColor(.blueDark)
                .previewDisplayName()

            Text("PROMOCODE", size: .small)
        }
        .padding(.medium)
    }
}

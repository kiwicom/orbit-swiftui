import SwiftUI

/// Orbit component that displays promo codes.
///
/// ```swift
/// Coupon("HXT3B81F")
///     .textColor(.blueDark)
///     .textSize(.small)
/// ```
///
/// ### Layout
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/visuals/coupon/)
public struct Coupon<Label: View>: View, PotentiallyEmptyView {

    @Environment(\.textSize) private var textSize

    @ViewBuilder private let label: Label

    public var body: some View {
        label
            .textSize(custom: textSize ?? Text.Size.small.value)
            .textFontWeight(.bold)
            .textIsCopyable()
            .padding(.horizontal, .xxSmall)
            .padding(.vertical, .xxxSmall)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .foregroundColor(.cloudDark)
            )
    }
    
    var isEmpty: Bool {
        label.isEmpty
    }
    
    /// Creates Orbit ``Coupon`` component with custom content.
    public init(@ViewBuilder _ label: () -> Label) {
        self.label = label()
    }
}

// MARK: - Convenience Inits
public extension Coupon where Label == Orbit.Text {
    
    /// Creates Orbit ``Coupon`` component.
    init(_ label: some StringProtocol = String("")) {
        self.init {
            Text(label)
        }
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

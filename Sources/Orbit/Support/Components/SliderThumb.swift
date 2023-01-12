import SwiftUI

struct SliderThumb: View {

    @Environment(\.sizeCategory) var sizeCategory

    public static let circleDiameter: CGFloat = 24
    public static let dotDiameter: CGFloat = 8

    public var body: some View {
        Circle()
            .frame(width: circleDiameter, height: circleDiameter)
            .foregroundColor(.white)
            .elevation(.level1)
            .overlay(indicatorSymbol)
    }

    @ViewBuilder var indicatorSymbol: some View {
        Circle()
            .foregroundColor(.blueNormal)
            .frame(width: dotDiameter, height: dotDiameter)
    }

    var circleDiameter: CGFloat {
        Self.circleDiameter * sizeCategory.controlRatio
    }

    var dotDiameter: CGFloat {
        Self.dotDiameter * sizeCategory.controlRatio
    }
}

struct SliderThumbPreview: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            SliderThumb()
                .previewDisplayName("SliderThumb")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI

public struct HairlineSeparator: View {

    public enum Orientation {
        case horizontal
        case vertical
    }

    let orientation: Orientation
    let color: Color

    public var body: some View {
        switch orientation {
            case .horizontal:
                color
                    .frame(height: BorderWidth.hairline)
            case .vertical:
                color
                    .frame(width: BorderWidth.hairline)
        }
    }

    public init(_ orientation: Orientation = .horizontal, color: Color = .cloudDarker) {
        self.orientation = orientation
        self.color = color
    }
}

// MARK: - Previews
struct HairlineSeparatorPreviews: PreviewProvider {

    static var previews: some View {

        PreviewWrapper {
            Group {
                HairlineSeparator(.horizontal)
                    .previewLayout(.fixed(width: 300, height: 300))
                HairlineSeparator(.vertical)
                    .previewLayout(.fixed(width: 300, height: 300))
            }
        }
    }
}

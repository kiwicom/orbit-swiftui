import SwiftUI

/// Displays flags of countries from around the world.
///
/// - Related components:
///   - ``Icon``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/countryflag/)
public struct CountryFlag: View {

    let countryCode: String
    let height: Height
    let border: Border

    public var body: some View {
        SwiftUI.Image(countryCode.lowercased(), bundle: .current)
            .resizable()
            .scaledToFit()
            .frame(height: height.value)
            .clipShape(clipShape)
            .overlay(
                clipShape.stroke(border.color, lineWidth: BorderWidth.thin)
            )
    }

    @ViewBuilder var clipShape: some Shape {
        RoundedRectangle(cornerRadius: height.value / 8)
    }
}

// MARK: - Inits
public extension CountryFlag {

    /// Creates Orbit CountryFlag component.
    init(_ countryCode: String, height: Height = .default, border: Border = .default) {
        self.countryCode = countryCode
        self.height = height
        self.border = border
    }
}

// MARK: - Types
public extension CountryFlag {

    enum Height: Equatable {
        /// 12 pts CountryFlag height.
        case small
        /// 16 pts CountryFlag height.
        case `default`
        /// 20 pts CountryFlag height.
        case medium
        /// 24pts CountryFlag height.
        case large
        /// Custom CountryFlag height.
        case custom(CGFloat)

        public var value: CGFloat {
            switch self {
                case .small:                return 12
                case .default:              return 16
                case .medium:               return 20
                case .large:                return 24
                case .custom(let size):     return size
            }
        }
    }

    enum Border {
        case none
        case `default`

        var color: Color {
            switch self {
                case .none:                 return .clear
                case .default:              return .cloudDark
            }
        }
    }
}

// MARK: - Previews
struct CountryFlagPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            CountryFlag("cz")
            CountryFlag("us", height: .small)
            CountryFlag("unknown", height: .large)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

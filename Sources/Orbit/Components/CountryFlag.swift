import SwiftUI

/// Displays flags of countries from around the world.
///
/// - Related components:
///   - ``Icon``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/countryflag/)
public struct CountryFlag: View {
    
    let countryCode: String
    let size: Icon.Size
    let border: Border

    public var body: some View {
        SwiftUI.Image(countryCode.lowercased(), bundle: .current)
            .resizable()
            .scaledToFit()
            .clipShape(clipShape)
            .overlay(
                clipShape.strokeBorder(border.color, lineWidth: BorderWidth.hairline)
                    .blendMode(.darken)
            )
            .padding(Icon.averagePadding)
            .frame(width: size.value)
            .fixedSize()
    }

    var clipShape: some InsettableShape {
        switch border {
            case .none:
                return RoundedRectangle(cornerRadius: 0)
            case .default:
                return RoundedRectangle(cornerRadius: size.value / 10)
        }
    }
}

// MARK: - Inits
public extension CountryFlag {

    /// Creates Orbit CountryFlag component.
    init(_ countryCode: String, size: Icon.Size = .normal, border: Border = .default) {
        self.countryCode = countryCode
        self.size = size
        self.border = border
    }
}

// MARK: - Types
public extension CountryFlag {

    enum Border {
        case none
        case `default`

        var color: Color {
            switch self {
                case .none:                 return .clear
                case .default:              return .cloudDarker.opacity(0.8)
            }
        }
    }
}

// MARK: - Previews
struct CountryFlagPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            CountryFlag("cz")
            CountryFlag("cz", border: .none)
            CountryFlag("sg")
            CountryFlag("jp")
            CountryFlag("de")
            CountryFlag("us", size: .small)
            CountryFlag("us", size: .custom(.xxxLarge))
            CountryFlag("unknown", size: .xLarge)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

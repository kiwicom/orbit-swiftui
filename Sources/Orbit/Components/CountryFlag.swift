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
            .padding(Icon.averagePadding / 2)
            .frame(width: size.value)
            .fixedSize()
    }

    var clipShape: some InsettableShape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
    
    var cornerRadius: CGFloat {
        switch border {
            case .none:                             return 0
            case .default(let cornerRadius?):       return cornerRadius
            case .default:                          return size.value / 10
        }
    }
}

// MARK: - Inits
public extension CountryFlag {

    /// Creates Orbit CountryFlag component.
    init(_ countryCode: String, size: Icon.Size = .normal, border: Border = .default()) {
        self.countryCode = countryCode
        self.size = size
        self.border = border
    }
}

// MARK: - Types
public extension CountryFlag {

    enum Border {
        case none
        case `default`(cornerRadius: CGFloat? = nil)

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
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var snapshots: some View {
        VStack {
            CountryFlag("cz")
            CountryFlag("cz", border: .default(cornerRadius: 10))
            CountryFlag("cz", border: .none)
            CountryFlag("sg")
            CountryFlag("jp")
            CountryFlag("de")
            CountryFlag("us", size: .small)
            CountryFlag("us", size: .custom(.xxxLarge))
            CountryFlag("unknown", size: .xLarge)
        }
        .padding()
    }
}

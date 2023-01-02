import SwiftUI

/// Displays flags of countries from around the world.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/countryflag/)
public struct CountryFlag: View {

    @Environment(\.sizeCategory) var sizeCategory

    let countryCode: CountryCode
    let size: Icon.Size
    let border: Border

    public var body: some View {
        SwiftUI.Image(countryCode.rawValue, bundle: .current)
            .resizable()
            .scaledToFit()
            .clipShape(clipShape)
            .overlay(
                clipShape.strokeBorder(border.color, lineWidth: BorderWidth.hairline)
                    .blendMode(.darken)
            )
            .frame(width: size.value * sizeCategory.ratio)
            .fixedSize()
            .accessibility(label: SwiftUI.Text(countryCode.rawValue))
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
    init(_ countryCode: CountryCode, size: Icon.Size = .normal, border: Border = .default()) {
        self.countryCode = countryCode
        self.size = size
        self.border = border
    }

    /// Creates Orbit CountryFlag component with a string country code.
    ///
    /// If a corresponding image is not found, the flag for unknown codes is used.
    init(_ countryCode: String, size: Icon.Size = .normal, border: Border = .default()) {
        self.countryCode = .init(countryCode)
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
                case .default:              return .cloudDark.opacity(0.8)
            }
        }
    }
}

// MARK: - Previews
struct CountryFlagPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            unknown
            mix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        CountryFlag("cz")
            .previewDisplayName()
    }

    static var unknown: some View {
        VStack {
            CountryFlag("")
            CountryFlag("some invalid identifier")
        }
        .previewDisplayName()
    }
    
    static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            flags(size: .small)
            flags(size: .normal)
            flags(size: .large)
            flags(size: .custom(40))

            HStack(alignment: .firstTextBaseline, spacing: .small) {
                Text("Borders")
                CountryFlag("CZ", size: .xLarge, border: .default(cornerRadius: 8))
                CountryFlag("cZ", size: .xLarge, border: .default(cornerRadius: 0))
                CountryFlag("Cz", size: .xLarge, border: .none)
            }
        }
        .previewDisplayName()
    }

    static func flags(size: Icon.Size) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text("\(size)".capitalized)
            CountryFlag("cz", size: size)
            CountryFlag("sg", size: size)
            CountryFlag("jp", size: size)
            CountryFlag("de", size: size)
            CountryFlag("unknown", size: size)
        }
        .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
    }

    static var snapshot: some View {
        mix
            .padding(.medium)
    }
}

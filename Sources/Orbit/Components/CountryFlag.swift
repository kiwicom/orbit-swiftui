import SwiftUI

/// Displays flags of countries from around the world.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/countryflag/)
public struct CountryFlag: View {

    @Environment(\.sizeCategory) var sizeCategory

    let countryCode: CountryCode
    let size: Size
    let border: Border

    public var body: some View {
        SwiftUI.Image(countryCode.rawValue, bundle: .orbit)
            .resizable()
            .scaledToFit()
            .clipShape(clipShape)
            .overlay(
                clipShape.strokeBorder(border.color, lineWidth: BorderWidth.hairline)
                    .blendMode(.darken)
            )
            .alignmentGuide(.firstTextBaseline) { $0[.bottom] }
            .alignmentGuide(.lastTextBaseline) { $0[.bottom] }
            .frame(width: width, height: height)
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
            case .default:                          return width / 10
        }
    }

    var width: CGFloat {
        switch size {
            case .width(let width):     return width * sizeCategory.ratio
            case .icon(let size):       return size.value * sizeCategory.ratio
        }
    }

    var height: CGFloat? {
        switch size {
            case .width:                return nil
            case .icon(let size):       return size.value * sizeCategory.ratio
        }
    }
}

// MARK: - Inits
public extension CountryFlag {

    /// Creates Orbit CountryFlag component.
    init(_ countryCode: CountryCode, size: Size = .normal, border: Border = .default()) {
        self.countryCode = countryCode
        self.size = size
        self.border = border
    }

    /// Creates Orbit CountryFlag component with a string country code.
    ///
    /// If a corresponding image is not found, the flag for unknown codes is used.
    init(_ countryCode: String, size: Size = .normal, border: Border = .default()) {
        self.init(
            .init(countryCode),
            size: size,
            border: border
        )
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

    enum Size {
        case width(_ width: CGFloat)
        case icon(_ size: Icon.Size = .normal)

        public static var small: Self {
            .icon(.small)
        }

        public static var normal: Self {
            .icon(.normal)
        }

        public static var large: Self {
            .icon(.large)
        }

        public static var xLarge: Self {
            .icon(.xLarge)
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
                CountryFlag("CZ", size: .icon(.xLarge), border: .default(cornerRadius: 8))
                CountryFlag("cZ", size: .icon(.xLarge), border: .default(cornerRadius: 0))
                CountryFlag("Cz", size: .icon(.xLarge), border: .none)
            }
        }
        .previewDisplayName()
    }

    static func flags(size: Icon.Size) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text("\(size)".capitalized)
            CountryFlag("cz", size: .icon(size))
            CountryFlag("sg", size: .icon(size))
            CountryFlag("jp", size: .icon(size))
            CountryFlag("de", size: .icon(size))
            CountryFlag("unknown", size: .icon(size))
        }
        .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
    }

    static var snapshot: some View {
        mix
            .padding(.medium)
    }
}

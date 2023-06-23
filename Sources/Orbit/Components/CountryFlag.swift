import SwiftUI

/// Displays flags of countries from around the world.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/countryflag/)
public struct CountryFlag: View {

    @Environment(\.textSize) var textSize
    @Environment(\.iconSize) var iconSize
    @Environment(\.sizeCategory) var sizeCategory

    let countryCode: CountryCode
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
            .frame(width: size, height: size)
            .alignmentGuide(.firstTextBaseline) { $0.height * Icon.symbolBaseline }
            .alignmentGuide(.lastTextBaseline) { $0.height * Icon.symbolBaseline }
            .accessibility(label: SwiftUI.Text(countryCode.rawValue))
    }

    var clipShape: some InsettableShape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
    
    var cornerRadius: CGFloat {
        switch border {
            case .none:                             return 0
            case .default(let cornerRadius?):       return cornerRadius
            case .default:                          return size / 10
        }
    }

    var size: CGFloat {
        (iconSize ?? textSize.map(Icon.Size.fromTextSize(size:)) ?? Icon.Size.normal.value) * sizeCategory.ratio
    }
}

// MARK: - Inits
public extension CountryFlag {

    /// Creates Orbit CountryFlag component.
    init(_ countryCode: CountryCode, border: Border = .default()) {
        self.countryCode = countryCode
        self.border = border
    }

    /// Creates Orbit CountryFlag component with a string country code.
    ///
    /// If a corresponding image is not found, the flag for unknown codes is used.
    init(_ countryCode: String, border: Border = .default()) {
        self.init(.init(countryCode), border: border)
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
            CountryFlag("invalid")
        }
        .previewDisplayName()
    }
    
    static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            flags(.small)
            flags(.normal)
            flags(.large)
            flags(size: 40)

            HStack(alignment: .firstTextBaseline, spacing: .small) {
                Text("Borders")
                CountryFlag("CZ", border: .default(cornerRadius: 8))
                CountryFlag("cZ", border: .default(cornerRadius: 0))
                CountryFlag("Cz", border: .none)
            }
            .iconSize(.xLarge)
        }
        .previewDisplayName()
    }

    static func flags(_ size: Icon.Size) -> some View {
        flags(size: size.value)
    }

    static func flags(size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text("\(size)".capitalized)
            CountryFlag("cz")
            CountryFlag("sg")
            CountryFlag("jp")
            CountryFlag("unknown")
        }
        .textSize(custom: size)
        .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
    }

    static var snapshot: some View {
        mix
            .padding(.medium)
    }
}

import SwiftUI

/// Orbit component that displays flag of a country.
///
/// ```swift
/// CountryFlag(.us)
///   .iconSize(.large)
/// ```
///
/// ### Layout
/// 
/// The component size can be modified by ``iconSize(_:)`` modifier.
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/countryflag/)
public struct CountryFlag: View, PotentiallyEmptyView {

    @Environment(\.textSize) private var textSize
    @Environment(\.iconSize) private var iconSize
    @Environment(\.sizeCategory) private var sizeCategory

    private let countryCode: CountryCode?
    private let border: Border?

    public var body: some View {
        if let countryCode {
            SwiftUI.Image(countryCode.rawValue, bundle: .orbit)
                .resizable()
                .scaledToFit()
                .clipShape(clipShape)
                .overlay(
                    clipShape.strokeBorder(border?.color ?? .clear, lineWidth: BorderWidth.hairline)
                        .blendMode(.darken)
                )
                .frame(width: size, height: size)
                .alignmentGuide(.firstTextBaseline) { $0.height * Icon.symbolBaseline }
                .alignmentGuide(.lastTextBaseline) { $0.height * Icon.symbolBaseline }
                .accessibility(label: SwiftUI.Text(countryCode.rawValue))
        }
    }
    
    var isEmpty: Bool {
        countryCode == nil
    }

    private var clipShape: some InsettableShape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
    
    private var cornerRadius: CGFloat {
        switch border {
            case .none:                             return 0
            case .default(let cornerRadius?):       return cornerRadius
            case .default:                          return size / 10
        }
    }

    private var size: CGFloat {
        (iconSize ?? textSize.map(Icon.Size.fromTextSize(size:)) ?? Icon.Size.normal.value) * sizeCategory.ratio
    }
}

// MARK: - Inits
public extension CountryFlag {

    /// Creates Orbit ``CountryFlag`` component.
    init(_ countryCode: CountryCode, border: Border? = .default()) {
        self.init(
            countryCode: countryCode,
            border: border
        )
    }

    /// Creates Orbit ``CountryFlag`` component using a country code string.
    ///
    /// - Note: If a corresponding image is not found, the flag for unknown flag is used.
    init(_ countryCode: String, border: Border? = .default()) {
        self.init(
            countryCode: countryCode.isEmpty ? nil : .init(countryCode),
            border: border
        )
    }
}

// MARK: - Types
public extension CountryFlag {

    /// Orbit ``CountryFlag`` border.
    enum Border {
        case `default`(cornerRadius: CGFloat? = nil)

        var color: Color {
            switch self {
                case .default:              return .cloudDark.opacity(0.8)
            }
        }
    }

    /// Orbit ``CountryFlag`` size.
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
            sizing
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
            CountryFlag("")  // EmptyView
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
                CountryFlag("Cz", border: nil)
            }
            .textSize(.xLarge)
        }
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Group {
                CountryFlag("cz")
                CountryFlag("sk")
                CountryFlag("us")
                CountryFlag(.us)
                    .iconSize(.large)
            }
            .measured()
        }
        .previewDisplayName()
    }

    static func flags(_ size: Icon.Size) -> some View {
        flags(size: size.value, label: String(describing: size).titleCased)
    }

    static func flags(size: CGFloat, label: String? = nil) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text("\(label ?? String(describing: Int(size)))".capitalized)
            CountryFlag("cz")
            CountryFlag("sg")
            CountryFlag("jp")
            CountryFlag("unknown")
        }
        .textSize(custom: size)
        .background(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
    }

    static var snapshot: some View {
        mix
            .padding(.medium)
    }
}

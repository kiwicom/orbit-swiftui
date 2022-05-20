import SwiftUI

/// Displays flags of countries from around the world.
///
/// - Related components:
///   - ``Icon``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/countryflag/)
public struct CountryFlag: View {

    @Environment(\.sizeCategory) var sizeCategory

    let countryCode: String
    let size: Icon.Size
    let border: Border

    public var body: some View {
        if countryCode.isEmpty == false {
            SwiftUI.Image(countryCode.lowercased(), bundle: .current)
                .resizable()
                .scaledToFit()
                .clipShape(clipShape)
                .overlay(
                    clipShape.strokeBorder(border.color, lineWidth: BorderWidth.hairline)
                        .blendMode(.darken)
                )
                .padding(Icon.averageIconContentPadding / 2)
                .frame(width: size.value * sizeCategory.ratio)
                .fixedSize()
                .accessibility(label: SwiftUI.Text(countryCode))
        }
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
            standalone
            storybook
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            CountryFlag("cz")
            CountryFlag("")     // EmptyView
        }
        .padding(.medium)
    }
    
    static var storybook: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                Text("Small")
                CountryFlag("cz", size: .small)
                CountryFlag("sg", size: .small)
                CountryFlag("jp", size: .small)
                CountryFlag("de", size: .small)
                CountryFlag("unknown", size: .small)
            }
            HStack(spacing: .small) {
                Text("Normal")
                CountryFlag("cz")
                CountryFlag("sg")
                CountryFlag("jp")
                CountryFlag("de")
                CountryFlag("unknown")
            }
            HStack(spacing: .small) {
                Text("Large")
                CountryFlag("cz", size: .large)
                CountryFlag("sg", size: .large)
                CountryFlag("jp", size: .large)
                CountryFlag("de", size: .large)
                CountryFlag("unknown", size: .large)
            }
            HStack(spacing: .small) {
                Text("Borders")
                CountryFlag("cz", size: .xLarge, border: .default(cornerRadius: 8))
                CountryFlag("cz", size: .xLarge, border: .default(cornerRadius: 0))
                CountryFlag("cz", size: .xLarge, border: .none)
            }
            HStack(spacing: .small) {
                Text("Custom size")
                CountryFlag("us", size: .custom(60))
            }
        }
        .padding()
    }
}

struct CountryFlagDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        CountryFlagPreviews.storybook
    }
}

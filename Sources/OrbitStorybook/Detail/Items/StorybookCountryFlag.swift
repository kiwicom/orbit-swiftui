import SwiftUI
import Orbit

struct StorybookCountryFlag {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                Text("Small")
                CountryFlag("cz")
                CountryFlag("sg")
                CountryFlag("jp")
                CountryFlag("de")
                CountryFlag("unknown")
            }
            .iconSize(.small)

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
                CountryFlag("cz")
                CountryFlag("sg")
                CountryFlag("jp")
                CountryFlag("de")
                CountryFlag("unknown")
            }
            .iconSize(.large)

            HStack(spacing: .small) {
                Text("Borders")
                CountryFlag("CZ", border: .default(cornerRadius: 8))
                CountryFlag("cZ", border: .default(cornerRadius: 0))
                CountryFlag("Cz", border: .none)
            }
            .iconSize(.xLarge)

            HStack(spacing: .small) {
                Text("Custom size")
                CountryFlag("us")
                    .iconSize(custom: 60)
            }
        }
        .previewDisplayName()
    }
}

struct StorybookCountryFlagPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCountryFlag.basic
        }
    }
}

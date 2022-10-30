import SwiftUI
import Orbit

struct StorybookCountryFlag {

    static var basic: some View {
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
                CountryFlag("CZ", size: .xLarge, border: .default(cornerRadius: 8))
                CountryFlag("cZ", size: .xLarge, border: .default(cornerRadius: 0))
                CountryFlag("Cz", size: .xLarge, border: .none)
            }
            HStack(spacing: .small) {
                Text("Custom size")
                CountryFlag("us", size: .custom(60))
            }
        }
    }
}

struct StorybookCountryFlagPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCountryFlag.basic
        }
    }
}

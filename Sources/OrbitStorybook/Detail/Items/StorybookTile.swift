import SwiftUI
import Orbit

struct StorybookTile {

    static let title = "Title"
    static let description = "Description"
    static let descriptionMultiline = """
        Description with <strong>very</strong> <ref>very</ref> <u>very</u> long multiline \
        description and <u>formatting</u> with <applink1>links</applink1>
        """

    static var basic: some View {
        VStack(spacing: .large) {
            Tile(title, action: {})
            Tile(title, icon: .airplane, action: {})
            Tile(title, description: description, action: {})
            Tile(title, description: description, icon: .airplane, action: {})
            Tile(action: {}) {
                contentPlaceholder
            }
        }
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .large) {
            Tile("Title with very very very very very long multiline text", description: descriptionMultiline, icon: .airplane, action: {}) {
                contentPlaceholder
            }
            Tile(title, description: description, icon: .symbol(.airplane, color: .blueNormal), action: {})
            Tile("SF Symbol", description: description, icon: .sfSymbol("info.circle.fill"), action: {})
                .status(.critical)
            Tile("Country Flag", description: description, icon: .countryFlag("cz"), disclosure: .buttonLink("Action", style: .primary), action: {})
            Tile(title, description: description, icon: .airplane, disclosure: .buttonLink("Action", style: .critical), action: {})
            Tile(title, description: description, icon: .airplane, disclosure: .icon(.grid), action: {})
            Tile(disclosure: .none, action: {}) {
                contentPlaceholder
            }
            Tile("Tile with custom content", disclosure: .none, action: {}) {
                contentPlaceholder
            }
            Tile(
                "Tile with no border",
                description: descriptionMultiline,
                icon: .grid,
                showBorder: false,
                action: {}
            )
        }
        .previewDisplayName()
    }
}

struct StorybookTilePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTile.basic
            StorybookTile.mix
        }
    }
}

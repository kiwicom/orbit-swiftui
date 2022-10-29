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
            Tile(title)
            Tile(title, icon: .airplane)
            Tile(title, description: description)
            Tile(title, description: description, icon: .airplane)
            Tile {
                contentPlaceholder
            }
        }
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .large) {
            Tile("Title with very very very very very long multiline text", description: descriptionMultiline, icon: .airplane) {
                contentPlaceholder
            }
            Tile(title, description: description, icon: .symbol(.airplane, color: .blueNormal), status: .info)
            Tile("SF Symbol", description: description, icon: .sfSymbol("info.circle.fill"), status: .critical)
            Tile("Country Flag", description: description, icon: .countryFlag("cz"), disclosure: .buttonLink("Action", style: .primary))
            Tile(title, description: description, icon: .airplane, disclosure: .buttonLink("Action", style: .critical))
            Tile(title, description: description, icon: .airplane, disclosure: .icon(.grid))
            Tile(disclosure: .none) {
                contentPlaceholder
            }
            Tile("Tile with custom content", disclosure: .none) {
                contentPlaceholder
            }
            Tile(
                "Tile with no border",
                description: descriptionMultiline,
                icon: .grid,
                showBorder: false
            )
        }
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

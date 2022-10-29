import SwiftUI
import Orbit

// MARK: - Card
struct StorybookCard {

    static var basic: some View {
        LazyVStack(spacing: .large) {
            standalone
            content
        }
    }

    static var standalone: some View {
        Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
            contentPlaceholder
            contentPlaceholder
        }
    }

    @ViewBuilder static var content: some View {
        cardWithoutContent
        cardWithFillLayoutContent
        cardWithFillLayoutContentNoHeader
        cardWithOnlyCustomContent
        cardWithTiles
        cardMultilineCritical
        clear
    }

    static var cardWithoutContent: some View {
        Card("Card with no content", action: .buttonLink("Edit"))
    }

    static var cardWithFillLayoutContent: some View {
        Card("Card with fill layout content", action: .buttonLink("Edit"), contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithFillLayoutContentNoHeader: some View {
        Card(contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithOnlyCustomContent: some View {
        Card {
            contentPlaceholder
            contentPlaceholder
        }
    }

    static var cardWithTiles: some View {
        Card("Card with mixed content", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
            contentPlaceholder
                .frame(height: 30).clipped()
            Tile("Tile")

            TileGroup {
                Tile("Tile in TileGroup 1")
                Tile("Tile in TileGroup 2")
            }

            TileGroup {
                Tile("Tile in TileGroup 1 (fixed)")
                Tile("Tile in TileGroup 2 (fixed)")
            }
            .fixedSize(horizontal: true, vertical: false)

            ListChoice("ListChoice 1")
                .padding(.trailing, -.medium)
            ListChoice("ListChoice 2")
                .padding(.trailing, -.medium)
            contentPlaceholder
                .frame(height: 30).clipped()
        }
    }

    static var cardMultilineCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("ButtonLink with a long description"),
            status: .critical
        ) {
            contentPlaceholder
        }
    }

    static var clear: some View {
        Card(
            "Card without borders and background",
            headerSpacing: .xSmall,
            showBorder: false,
            backgroundColor: .clear,
            contentLayout: .fill
        ) {
            VStack(spacing: 0) {
                ListChoice("ListChoice")
                ListChoice("ListChoice", icon: .countryFlag("us"))
                ListChoice("ListChoice", description: "ListChoice description", icon: .airplane, showSeparator: false)
            }
            .padding(.top, .xSmall)
        }
    }
}

struct StorybookCardPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCard.basic
        }
    }
}

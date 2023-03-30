import SwiftUI
import Orbit

// MARK: - Card
struct StorybookCard {

    static var basic: some View {
        LazyVStack(spacing: .large) {
            standalone
            content
        }
        .previewDisplayName()
    }

    static var standalone: some View {
        Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink", action: {})) {
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
        Card("Card with no content", action: .buttonLink("Edit", action: {}))
    }

    static var cardWithFillLayoutContent: some View {
        Card("Card with fill layout content", action: .buttonLink("Edit", action: {}), contentLayout: .fill) {
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
        Card("Card with mixed content", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink", action: {})) {
            contentPlaceholder
                .frame(height: 30).clipped()
            Tile("Tile", action: {})

            TileGroup {
                Tile("Tile in TileGroup 1", action: {})
                Tile("Tile in TileGroup 2", action: {})
            }

            TileGroup {
                Tile("Tile in TileGroup 1 (fixed)", action: {})
                Tile("Tile in TileGroup 2 (fixed)", action: {})
            }
            .fixedSize(horizontal: true, vertical: false)

            ListChoice("ListChoice 1", action: {})
                .padding(.trailing, -.medium)
            ListChoice("ListChoice 2", action: {})
                .padding(.trailing, -.medium)
            contentPlaceholder
                .frame(height: 30).clipped()
        }
    }

    static var cardMultilineCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("ButtonLink with a long description", action: {})
        ) {
            contentPlaceholder
        }
        .status(.critical)
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
                ListChoice("ListChoice", action: {})
                ListChoice("ListChoice", icon: .countryFlag("us"), action: {})
                ListChoice("ListChoice", description: "ListChoice description", icon: .airplane, showSeparator: false, action: {})
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

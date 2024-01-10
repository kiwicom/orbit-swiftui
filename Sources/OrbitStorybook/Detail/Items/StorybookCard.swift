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
        VStack(spacing: .medium) {
            Card("Card", description: StorybookTile.descriptionMultiline) {
                contentPlaceholder
                contentPlaceholder
            } action: {
                ButtonLink("ButtonLink", action: {})
            }
            
            Card("Card with custom layout", description: StorybookTile.descriptionMultiline, contentPadding: 0) {
                contentPlaceholder
                contentPlaceholder
            } action: {
                ButtonLink("ButtonLink", action: {})
            }
            
            Card("Card with no content", description: StorybookTile.descriptionMultiline) {
                EmptyView()
            } action: {
                ButtonLink("Edit", type: .critical, action: {})
            }
        }
        .previewDisplayName()
    }

    @ViewBuilder static var content: some View {
        cardWithFillLayoutContentNoHeader
        cardWithOnlyCustomContent
        cardWithTiles
        cardMultilineCritical
        clear
    }

    static var cardWithFillLayoutContentNoHeader: some View {
        Card(contentPadding: 0) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithOnlyCustomContent: some View {
        Card(contentPadding: 0) {
            contentPlaceholder
            contentPlaceholder
        }
    }

    static var cardWithTiles: some View {
        Card("Card with mixed content", description: "Card description", contentPadding: 0) {
            contentPlaceholder
            
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
        } action: {
            ButtonLink("ButtonLink", action: {})
        }
        
    }

    static var cardMultilineCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description"
        ) {
            contentPlaceholder
        } action: {
            ButtonLink("ButtonLink with a long description", action: {})
        }
        .status(.critical)
    }

    static var clear: some View {
        Card(
            "Card without borders and background",
            showBorder: false,
            contentPadding: 0
        ) {
            ListChoice("ListChoice", action: {})
            ListChoice("ListChoice") {
                // No action
            } icon: {
                CountryFlag("us")
            }
            ListChoice("ListChoice", description: "ListChoice description", icon: .airplane, showSeparator: false, action: {})
        }
        .backgroundStyle(.clear)
    }
}

struct StorybookCardPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCard.basic
        }
    }
}

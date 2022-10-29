import SwiftUI
import Orbit

struct StorybookTileGroup {

    static var basic: some View {
        TileGroup {
            tiles(intrinsic: false)
        }
    }

    @ViewBuilder static func tiles(intrinsic: Bool) -> some View {
        Tile("Title")
        Tile("Custom content", icon: .grid, action: {}) {
            if intrinsic {
                intrinsicContentPlaceholder
            } else {
                contentPlaceholder
            }
        }
        Tile("Title", description: "No disclosure", icon: .notification, disclosure: .none)
        Tile("No Separator", icon: .notification)
            .tileSeparator(false)
        Tile("Title", description: "Description", icon: .airplane)
    }
}

struct StorybookTileGroupPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTileGroup.basic
        }
    }
}

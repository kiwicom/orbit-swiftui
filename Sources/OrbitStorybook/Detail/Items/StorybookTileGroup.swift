import SwiftUI
import Orbit

struct StorybookTileGroup {

    static var basic: some View {
        TileGroup {
            tiles(intrinsic: false)
        }
        .previewDisplayName()
    }

    @ViewBuilder static func tiles(intrinsic: Bool) -> some View {
        Tile("Title", action: {})
        Tile("Custom content", icon: .grid, action: {}) {
            if intrinsic {
                intrinsicContentPlaceholder
            } else {
                contentPlaceholder
            }
        }
        Tile("Title", description: "No disclosure", icon: .notification, disclosure: .none, action: {})
        Tile("No Separator", icon: .notification, action: {})
            .tileSeparator(false)
        Tile("Title", description: "Description", icon: .airplane, action: {})
    }
}

struct StorybookTileGroupPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTileGroup.basic
        }
    }
}

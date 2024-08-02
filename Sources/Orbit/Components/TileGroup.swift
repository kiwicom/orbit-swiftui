import SwiftUI

/// Orbit component that wraps multiple ``Tile``s to show related interactions.
///
/// A ``TileGroup`` consists of a set of ``Tile`` content:
/// 
/// ```swift
/// TileGroup {
///     Tile("Title 1")
///     Tile("Title 2")
/// }
/// ```
///
/// All tiles in a group include bottom separators by default, except for the last separator.
/// Use ``showsSeparator(_:)`` to modify separator visibility for a given tile:
///
/// ```swift
/// TileGroup {
///     Tile("Tile with no Separator")
///         .showsSeparator(false)
///     Tile("Tile 2")
/// }
/// ```
///
/// ### Layout
/// 
/// The component adds a `VStack` over the provided content. Avoid using the component when the content is large and should be embedded in a lazy stack.
///
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/tilegroup/)
public struct TileGroup<Tiles: View>: View, PotentiallyEmptyView {

    @ViewBuilder private let tiles: Tiles

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .leading, spacing: 0) {
                tiles
                    .environment(\.isInsideTileGroup, true)
            }
            // hide any last separator automatically by clipping it
            .padding(.bottom, -1)
            .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default))
            .compositingGroup()
            .elevation(.level1, shape: .roundedRectangle())
        }
    }

    var isEmpty: Bool {
        tiles.isEmpty
    }
    
    /// Creates Orbit ``TileGroup`` component.
    public init(@ViewBuilder _ tiles: () -> Tiles) {
        self.tiles = tiles()
    }
}

// MARK: - Previews
struct TileGroupPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            idealSize
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TileGroup {
            tiles(intrinsic: false)
        }
        .previewDisplayName()
    }

    static var idealSize: some View {
        TileGroup {
            tiles(intrinsic: true)
        }
        .fixedSize(horizontal: true, vertical: false)
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
        Tile {
            // No action
        } content: {
            if intrinsic {
                intrinsicContentPlaceholder
            } else {
                contentPlaceholder
            }
        }
        Tile("Title", description: "No disclosure", icon: .notification, disclosure: .none, action: {})
        Tile("No Separator", icon: .notification, action: {})
            .showsSeparator(false)
        Tile("Title", description: TilePreviews.description, icon: .airplane, action: {})
    }

    static var snapshot: some View {
        VStack(spacing: .medium) {
            standalone
            idealSize
        }
        .padding(.medium)
    }
}

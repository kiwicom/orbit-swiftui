import SwiftUI

/// Wraps tiles to show related interactions.
///
/// Only ``Tile``s should be used inside of a group.
///
/// Tiles in a group show separators by default, except for the last tile,
/// which is handled automatically and never shows a separator.
///
/// Use ``Tile/tileSeparator(_:)`` to modify separator visibility for a given tile:
///
/// ```swift
/// TileGroup {
///     Tile("Title")
///     Tile("No Separator")
///         .tileSeparator(false)
///     Tile("Title")
/// }
/// ```
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tilegroup/)
public struct TileGroup<Content: View>: View, PotentiallyEmptyView {

    @ViewBuilder let content: Content

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .leading, spacing: 0) {
                content
                    .environment(\.isInsideTileGroup, true)
            }
            // hide any last separator automatically by clipping it
            .padding(.bottom, -Separator.Thickness.default.value)
            .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default))
            .compositingGroup()
            .elevation(.level1, shape: .roundedRectangle())
        }
    }

    var isEmpty: Bool {
        content.isEmpty
    }

    /// Creates Orbit TileGroup component as a wrapper for Tile content.
    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
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
            .tileSeparator(false)
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

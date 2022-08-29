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
public struct TileGroup<Content: View>: View {

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
        content is EmptyView
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
            intrinsic
            Tile("Standalone Tile", icon: .grid)
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TileGroup {
            tiles(intrinsic: false)
        }
    }

    static var intrinsic: some View {
        TileGroup {
            tiles(intrinsic: true)
        }
        .idealSize()
        .previewDisplayName("Intrinsic")
    }

    static var storybook: some View {
        standalone
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
        Tile("Title", description: TilePreviews.description, icon: .airplane)
    }

    static var snapshot: some View {
        standalone
            .padding(.medium)
    }
}

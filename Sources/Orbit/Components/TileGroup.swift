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
            .clipShape(clipShape)
            .compositingGroup()
            .elevation(.level1)
        }
    }

    var clipShape: some InsettableShape {
        RoundedRectangle(cornerRadius: BorderRadius.default)
            // hide the last separator automatically
            .inset(by: Separator.Thickness.default.value)
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

            Tile("Standalone Tile", icon: .grid)
                .padding(.medium)
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TileGroup {
            tiles
        }
        .padding(.medium)
    }

    static var storybook: some View {
        standalone
    }

    @ViewBuilder static var tiles: some View {
        Tile("Title")
        Tile("Title with custom content", icon: .grid) {
            customContentPlaceholder
        }
        Tile("Title", description: "No disclosure", icon: .notification, disclosure: .none)
        Tile("No Separator", icon: .notification)
            .tileSeparator(false)
        Tile("Title", description: TilePreviews.description, icon: .airplane)
    }

    static var snapshot: some View {
        standalone
    }
}

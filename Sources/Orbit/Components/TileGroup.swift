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
/// - Important: Expands horizontally up to ``Layout/readableMaxWidth`` by default and then centered. Can be adjusted by `width` property.
public struct TileGroup<Content: View>: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let status: Status?
    let backgroundColor: Color?
    let width: ContainerWidth
    @ViewBuilder let content: Content

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .leading, spacing: 0) {
                content
                    .environment(\.isInsideTileGroup, true)
            }
            .clipShape(clipShape)
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
}

// MARK: - Inits
public extension TileGroup {
    
    /// Creates Orbit TileGroup component as a wrapper for Tile content.
    init(
        status: Status? = nil,
        backgroundColor: Color? = nil,
        width: ContainerWidth = .expanding(),
        @ViewBuilder content: () -> Content
    ) {
        self.status = status
        self.backgroundColor = backgroundColor
        self.width = width
        self.content = content()
    }
}

// MARK: - Previews
struct TileGroupPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
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
        VStack(spacing: .large) {
            TileGroup {
                tiles
            }

            TileGroup(status: .critical) {
                tiles
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var tiles: some View {
        Tile("Title")
        Tile("Title") {
            customContentPlaceholder
        }
        Tile("Title", icon: .notification)
        Tile("No Separator", icon: .notification)
            .tileSeparator(false)
        Tile("Title", description: TilePreviews.description, icon: .airplane)
    }

    static var snapshot: some View {
        standalone
    }
}

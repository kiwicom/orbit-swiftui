import SwiftUI

/// Wraps tiles to show related interactions.

/// - Related components:
///   - ``Tile``
///   - ``Card``
///   - ``ChoiceTile``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tilegroup/)
/// - Important: Expands horizontally up to ``Layout/readableMaxWidth`` by default and then centered. Can be adjusted by `width` property.
public struct TileGroup<Content: View>: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let status: Status?
    let backgroundColor: Color?
    let width: ContainerWidth
    let content: () -> Content

    public var body: some View {
        Card(borderStyle: .default, status: status, width: width, backgroundColor: backgroundColor, contentLayout: .fill) {
            content()
        }
    }
}

// MARK: - Inits
public extension TileGroup {
    
    /// Creates Orbit TileGroup component as a wrapper for Tile content.
    ///
    /// - Parameters:
    ///   - style: Appearance of TileGroup. Can be styled to match iOS default table section.
    init(
        status: Status? = nil,
        backgroundColor: Color? = nil,
        width: ContainerWidth = .expanding(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.status = status
        self.backgroundColor = backgroundColor
        self.width = width
        self.content = content
    }
}

// MARK: - Previews
struct TileGroupPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TileGroup {
            defaultTiles
        }
    }

    static var figma: some View {
        VStack(spacing: .large) {
            standalone
                .padding(.horizontal, .medium)
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Figma")
    }

    static var snapshots: some View {
        VStack(spacing: .large) {
            standalone

            TileGroup(status: .critical) {
                defaultTiles
            }
        }
        .padding()
        .background(Color.cloudLight)
        .previewDisplayName("Style - Default")
    }

    @ViewBuilder static var defaultTiles: some View {
        Tile("Title", border: .separator)

        Tile("Title", icon: .notification, border: .separator)

        Tile("No Separator", icon: .notification, border: .none)

        Tile(
            "Title",
            description: TilePreviews.description,
            icon: .airplane,
            border: .separator
        )
    }
}

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
        Tile("Title", border: .separator)
        Tile("Title", border: .separator) {
            customContentPlaceholder
        }
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

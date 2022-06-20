import SwiftUI

/// Wraps tiles to show related interactions.
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
            Card(borderStyle: .default, status: status, width: width, backgroundColor: backgroundColor, contentLayout: .fill) {
                content
            }
        }
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

    static var snapshot: some View {
        standalone
    }
}

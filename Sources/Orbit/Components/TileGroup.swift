import SwiftUI

public enum TileGroupStyle {
    case `default`
    /// A style that visually matches the iOS plain table section appearance.
    case iOS
    
    public var tileBorderStyle: TileBorderModifier.Style {
        switch self {
            case .default:      return .default
            case .iOS:          return .iOS
        }
    }
    
    public var cardStyle: CardStyle {
        switch self {
            case .default:      return .default
            case .iOS:          return .iOS
        }
    }
}

/// Wraps tiles to show related interactions.

/// - Related components:
///   - ``Tile``
///   - ``Card``
///   - ``ChoiceTile``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tilegroup/)
/// - Important: Component expands horizontally to infinity up to a ``Layout/readableMaxWidth``.
public struct TileGroup<Content: View>: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let style: TileGroupStyle
    let status: Status?
    let backgroundColor: Color?
    let content: () -> Content

    public var body: some View {
        Card(spacing: 0, padding: 0, style: style.cardStyle, status: status, backgroundColor: backgroundColor) {
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
        style: TileGroupStyle = .default,
        status: Status? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.status = status
        self.backgroundColor = backgroundColor
        self.content = content
    }
}

// MARK: - Previews
struct TileGroupPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            snapshots
            snapshotsIOS
            snapshotsIOSRegular
            snapshotsIOSRegularNarrow
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
            iOSTileGroups
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

    static var snapshotsIOS: some View {
        iOSTileGroups
            .background(Color.cloudLight)
            .previewDisplayName("Style - iOS")
    }

    static var snapshotsIOSRegular: some View {
        iOSTileGroups
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth + 100)
            .previewDisplayName("Style - iOS Regular")
    }

    static var snapshotsIOSRegularNarrow: some View {
        iOSTileGroups
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth - 200)
            .previewDisplayName("Style - iOS Regular narrow")
    }

    static var iOSTileGroups: some View {
        VStack(spacing: .medium) {
            TileGroup(style: .iOS) {
                iOSTiles
            }

            TileGroup(style: .iOS, status: .critical) {
                iOSTiles
            }
        }
        .padding(.vertical)
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

    @ViewBuilder static var iOSTiles: some View {
        Tile("Title", border: .separator, style: .iOS)

        Tile("Title", icon: .notification, border: .separator, style: .iOS)

        Tile("No Separator", icon: .notification, border: .none, style: .iOS)

        Tile(
            "Title",
            description: TilePreviews.description,
            icon: .airplane,
            border: .separator,
            style: .iOS
        )
    }
}

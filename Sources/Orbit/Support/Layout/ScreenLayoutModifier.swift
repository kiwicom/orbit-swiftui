import SwiftUI

/// Padding to apply in Orbit `screenLayout` context.
public enum ScreenLayoutPadding {
    /// Padding of `medium` size in compact horizontal size and `xxLarge` size in regular horizontal size.
    case `default`
    /// Padding of `medium` size in both compact and regular horizontal size.
    case compact
    /// Custom fixed padding.
    case custom(horizontal: CGFloat = .medium, top: CGFloat = .medium, bottom: CGFloat = .medium)

    public func horizontal(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        switch self {
            case .default:                      return `default`(horizontalSizeClass: horizontalSizeClass)
            case .compact:                      return .medium
            case .custom(let horizontal, _, _): return horizontal
        }
    }

    public func top(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        switch self {
            case .default:                      return `default`(horizontalSizeClass: horizontalSizeClass)
            case .compact:                      return .medium
            case .custom(_, let top, _):        return top
        }
    }

    public func bottom(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        switch self {
            case .default:                      return `default`(horizontalSizeClass: horizontalSizeClass)
            case .compact:                      return .medium
            case .custom(_, _, let bottom):     return bottom
        }
    }

    public func `default`(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        horizontalSizeClass == .regular
            ? .xxLarge
            : .medium
    }
}

struct ScreenLayoutModifier: ViewModifier {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let edges: Edge.Set
    let padding: ScreenLayoutPadding
    let alignment: HorizontalAlignment
    let maxContentWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .environment(\.screenLayoutPadding, padding)
            .padding(.top, edges.contains(.top) ? padding.top(horizontalSizeClass: horizontalSizeClass) : 0)
            .padding(.leading, edges.contains(.leading) ? padding.horizontal(horizontalSizeClass: horizontalSizeClass) : 0)
            .padding(.trailing, edges.contains(.trailing) ? padding.horizontal(horizontalSizeClass: horizontalSizeClass) : 0)
            .padding(.bottom, edges.contains(.bottom) ? padding.bottom(horizontalSizeClass: horizontalSizeClass) : 0)
            // Fill the width based on alignment
            .frame(maxWidth: maxContentWidth, alignment: .init(horizontal: alignment, vertical: .center))
            // Fill the rest of available width, aligning the content to center
            .frame(maxWidth: .infinity)
    }
}

public extension View {

    /// Adds unified Orbit layout to a screen for both `regular` and `compact` width environment.
    ///
    /// Screen layout adds maximum width and padding behaviour for provided content, horizontally expanding to `infinity`.
    ///
    /// A component can inspect the ``ScreenLayoutPaddingKey`` environment key to act upon this modifier.
    /// One example is a `Card` component that ignores horizontal paddings in `compact` environment.
    ///
    /// - Parameters:
    ///   - edges: The set of edges to pad for this view. The default is `Edge.Set.all`.
    ///   - padding: The padding to apply for specified edges.
    ///   - alignment: The alignment of the screen content. The default is `.leading`.
    ///   - maxContentWidth: Maximum width of content, horizontally aligned to center. The default value of this
    ///     parameter is ``Layout/readableMaxWidth``.
    func screenLayout(
        _ edges: Edge.Set = .all,
        padding: ScreenLayoutPadding = .default,
        alignment: HorizontalAlignment = .leading,
        maxContentWidth: CGFloat = Layout.readableMaxWidth
    ) -> some View {
        modifier(
            ScreenLayoutModifier(
                edges: edges,
                padding: padding,
                alignment: alignment,
                maxContentWidth: maxContentWidth
            )
        )
    }
}

// MARK: - Previews
struct ScreenLayoutModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            Group {
                fullDefault
                fullCompact
                fullCustom
                horizontal
                horizontalAndBottom
                noPaddingCustomWidth
                snapshot
            }
            .previewLayout(.sizeThatFits)

            ScrollView {
                snapshot
            }
        }
    }

    static var fullDefault: some View {
        Color.white
            .screenLayout()
            .background(Color.greenLight)
            .previewDisplayName()
    }

    static var fullCompact: some View {
        Color.white
            .screenLayout(padding: .compact)
            .background(Color.greenLight)
            .previewDisplayName()
    }

    static var fullCustom: some View {
        Color.white
            .screenLayout(padding: .custom(horizontal: .xxSmall, top: .xxxLarge, bottom: .medium))
            .background(Color.greenLight)
            .previewDisplayName()
    }

    static var horizontal: some View {
        Color.white
            .screenLayout(.horizontal)
            .background(Color.greenLight)
            .previewDisplayName()
    }

    static var horizontalAndBottom: some View {
        Color.white
            .screenLayout([.horizontal, .bottom])
            .background(Color.greenLight)
            .previewDisplayName()
    }

    static var noPaddingCustomWidth: some View {
        Color.white
            .screenLayout([], maxContentWidth: 200)
            .background(Color.greenLight)
            .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Alert(AlertPreviews.title, description: AlertPreviews.description) {
                illustrationPlaceholder
                    .padding(.horizontal, .xxLarge)
            } buttons: {
                Button("Primary") {}
                Button("Secondary") {}
            } icon: {
                Icon(.grid)
            }

            Text(TextPreviews.multilineFormattedText)

            illustrationPlaceholder
                .padding(.horizontal, .xxLarge)

            Button("Button", icon: .grid, action: {})

            Card("Card title", description: "Card description") {
                VStack(spacing: .medium) {
                    TileGroup {
                        Tile("Tile 1", action: {})
                        Tile("Tile 2", action: {})
                    }
                    Tile("Tile 3", action: {})
                    contentPlaceholder
                }
            } action: {
                ButtonLink("ButtonLink", action: {})
            }

            TileGroup {
                Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid, action: {})
                Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid, action: {})
            }

            Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid, action: {})

            Card("Card", contentPadding: 0) {
                ListChoice(ListChoicePreviews.title, value: ListChoicePreviews.value, action: {})
                ListChoice(ListChoicePreviews.title, description: ListChoicePreviews.description, action: {})
            }
        }
        .screenLayout()
        .background(Color.screen)
        .previewDisplayName()
    }
}

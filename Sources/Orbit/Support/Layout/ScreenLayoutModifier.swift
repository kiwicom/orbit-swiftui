import SwiftUI

struct ScreenLayoutModifier: ViewModifier {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let horizontalPadding: CGFloat
    let topPadding: CGFloat
    let regularWidthTopPadding: CGFloat
    let bottomPadding: CGFloat
    let regularWidthBottomPadding: CGFloat
    let maxContentWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .environment(\.isInsideScreenLayout, true)
            .padding(.top, horizontalSizeClass == .regular ? regularWidthTopPadding : topPadding)
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, horizontalSizeClass == .regular ? regularWidthBottomPadding : bottomPadding)
            .frame(maxWidth: maxContentWidth)
            .frame(maxWidth: .infinity)
    }
}

public extension View {

    /// Adds unified screen layout for both `regular` and `compact` width environment.
    ///
    /// Screen layout adds maximum width and padding behaviour for provided content.
    /// A component can inspect the `IsInsideScreenLayoutKey` environment key to act upon this modifier.
    /// One example is a `Card` component that ignores horizontal paddings in `compact` environment.
    func screenLayout(
        horizontalPadding: CGFloat = .medium,
        topPadding: CGFloat = .medium,
        regularWidthTopPadding: CGFloat = .xxLarge,
        bottomPadding: CGFloat = .medium,
        regularWidthBottomPadding: CGFloat = .xxLarge,
        maxContentWidth: CGFloat = Layout.readableMaxWidth
    ) -> some View {
        modifier(
            ScreenLayoutModifier(
                horizontalPadding: horizontalPadding,
                topPadding: topPadding,
                regularWidthTopPadding: regularWidthTopPadding,
                bottomPadding: bottomPadding,
                regularWidthBottomPadding: regularWidthBottomPadding,
                maxContentWidth: maxContentWidth
            )
        )
    }
}

// MARK: - Previews
struct ScreenLayoutModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            snapshot
                .previewLayout(.sizeThatFits)

            ScrollView {
                snapshot
            }
        }
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Alert(AlertPreviews.title, description: AlertPreviews.description, icon: .grid, buttons: AlertPreviews.primaryAndSecondaryConfiguration) {
                Illustration(.accommodation)
                    .padding(.horizontal, .xxLarge)
            }

            Text(TextPreviews.multilineFormattedText)

            Illustration(.accommodation)
                .padding(.horizontal, .xxLarge)

            Button("Button", icon: .grid)

            Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
                TileGroup {
                    Tile("Tile 1")
                    Tile("Tile 2")
                }
                Tile("Tile 3")
                customContentPlaceholder
            }

            TileGroup {
                Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid)
                Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid)
            }

            Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid)

            Card("Card", contentLayout: .fill) {
                ListChoice(ListChoicePreviews.title, value: ListChoicePreviews.value)
                ListChoice(ListChoicePreviews.title, description: ListChoicePreviews.description)
            }
        }
        .screenLayout()
        .background(Color.cloudNormal)
    }
}

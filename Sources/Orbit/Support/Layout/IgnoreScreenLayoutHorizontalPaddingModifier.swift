import SwiftUI

struct IgnoreScreenLayoutHorizontalPaddingModifier: ViewModifier {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.screenLayoutPadding) var screenLayoutPadding

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
    }

    var horizontalPadding: CGFloat {
        guard horizontalSizeClass != .regular, let screenLayoutPadding = screenLayoutPadding else {
            return 0
        }

        return -screenLayoutPadding.horizontal(horizontalSizeClass: horizontalSizeClass)
    }
}

public extension View {

    /// Reverts any horizontal padding provided by `screenLayout` context in a compact width environment.
    ///
    /// A typical usage is to mimic the edge-to-edge appearance of the `Card` component.
    func ignoreScreenLayoutHorizontalPadding() -> some View {
        modifier(IgnoreScreenLayoutHorizontalPaddingModifier())
    }
}

// MARK: - Previews
struct ScreenLayoutHorizontalPaddingModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content(padding: .default)
                .screenLayout()

            content(padding: .compact)
                .screenLayout(padding: .compact, maxContentWidth: 300)
        }
        .previewLayout(.sizeThatFits)
    }

    static func content(padding: ScreenLayoutPadding) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Heading("Heading", style: .title1)

            Card("Card", contentLayout: .fill) {
                ListChoice("ListChoice")
            }

            Color.blueLight
                .frame(height: 100)
                .ignoreScreenLayoutHorizontalPadding()
                .overlay(
                    Text("Edge-to-edge content with no horizontal padding")
                        .padding(.medium)
                )

            Button("Button")
        }
        .border(Color.cloudLight)
    }
}

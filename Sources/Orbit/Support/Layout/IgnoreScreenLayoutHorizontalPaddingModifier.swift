import SwiftUI

struct IgnoreScreenLayoutHorizontalPaddingModifier: ViewModifier {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.screenLayoutPadding) var screenLayoutPadding

    var limitToSizeClass: UserInterfaceSizeClass?

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
    }

    var horizontalPadding: CGFloat {
        guard let screenLayoutPadding = screenLayoutPadding else { return 0 }
        guard limitToSizeClass == nil || limitToSizeClass == horizontalSizeClass else { return 0 }

        return -screenLayoutPadding.horizontal(horizontalSizeClass: horizontalSizeClass)
    }
}

public extension View {

    /// Reverts any horizontal padding provided by `screenLayout` context. Can be optionally limited to a specific horizontal size class.
    ///
    /// A typical usage is to mimic the edge-to-edge appearance of the `Card` component.
    func ignoreScreenLayoutHorizontalPadding(limitToSizeClass sizeClass: UserInterfaceSizeClass? = nil) -> some View {
        modifier(IgnoreScreenLayoutHorizontalPaddingModifier(limitToSizeClass: sizeClass))
    }
}

// MARK: - Previews
struct ScreenLayoutHorizontalPaddingModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content(padding: .default)
                .screenLayout()
                .previewDisplayName("Default")

            content(padding: .compact)
                .screenLayout(padding: .compact, maxContentWidth: 300)
                .previewDisplayName("Limited width")
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
                .ignoreScreenLayoutHorizontalPadding(limitToSizeClass: .compact)
                .overlay(
                    Text("Card-like ignored horizontal padding in compact")
                        .padding(.medium)
                )

            Color.greenLight
                .frame(height: 100)
                .ignoreScreenLayoutHorizontalPadding(limitToSizeClass: .regular)
                .overlay(
                    Text("Card-like ignored horizontal padding in regular")
                        .padding(.medium)
                )

            Color.orangeLight
                .frame(height: 100)
                .ignoreScreenLayoutHorizontalPadding()
                .overlay(
                    Text("Card-like ignored horizontal padding in regular and compact")
                        .padding(.medium)
                )

            Button("Button")
        }
        .border(Color.cloudLight)
    }
}

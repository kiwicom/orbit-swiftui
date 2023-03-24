import SwiftUI
import Orbit

struct StorybookHorizontalScroll: View {

    @State var animatedScroll = true

    var body: some View {
        LazyVStack(alignment: .leading, spacing: .medium) {
            Heading("Item width: Ratio (0.8)", style: .title2)

            ratio

            Heading("Item width: Custom", style: .title2)
                .padding(.top, .xxxLarge)

            fixed

            Heading("Inside Cards", style: .title2)
                .padding(.top, .xxxLarge)

            insideCards

            if #available(iOS 14, *) {
                Heading("Programmatic scrolling", style: .title2)
                    .padding(.top, .xxxLarge)
                
                tapToScroll
            }
        }
    }

    var ratio: some View {
        LazyVStack(alignment: .leading, spacing: .medium) {
            Heading("Snapping", style: .title4)

            HorizontalScroll {
                tileVariants
            }

            Heading("No snapping", style: .title4)

            HorizontalScroll(isSnapping: false, spacing: .large) {
                tileVariants
            }
        }
        .previewDisplayName()
    }

    var fixed: some View {
        LazyVStack(alignment: .leading, spacing: .medium) {
            Heading("Snapping", style: .title4)

            HorizontalScroll(isSnapping: true, itemWidth: .fixed(180)) {
                tileVariants
            }

            Heading("No snapping", style: .title4)

            HorizontalScroll(isSnapping: false, spacing: .medium, itemWidth: .fixed(180)) {
                tileVariants
            }
        }
        .previewDisplayName()
    }

    var fitting: some View {
        LazyVStack(alignment: .leading, spacing: .medium) {
            Heading("Snapping", style: .title4)

            HorizontalScroll(isSnapping: true, itemWidth: .fixed(180)) {
                tile
            }

            Heading("No snapping", style: .title4)

            HorizontalScroll(isSnapping: false, spacing: .medium, itemWidth: .fixed(180)) {
                tile
            }
        }
        .previewDisplayName()
    }

    var insideCards: some View {
        LazyVStack(alignment: .leading, spacing: .medium) {
            Card("Snapping") {
                HorizontalScroll(itemWidth: .ratio(0.5)) {
                    tileVariants
                }
            }

            Card("No Snapping") {
                HorizontalScroll(isSnapping: false, spacing: .medium, itemWidth: .ratio(0.5)) {
                    tileVariants
                }
            }
        }
        .previewDisplayName()
    }

    @available(iOS 14, *)
    @ViewBuilder var tapToScroll: some View {
        HorizontalScrollReader { scrollProxy in
            VStack(alignment: .leading, spacing: .medium) {
                HorizontalScroll {
                    tile
                        .identifier(0)

                    ForEach(1..<5) { index in
                        Tile("Tile \(index)", description: "Tap to scroll to previous") {
                            scrollProxy.scrollTo(index - 1, animated: animatedScroll)
                        }
                        .identifier(index)
                    }

                    largerTile
                        .identifier(5)

                    expandingWidthTile
                        .identifier(6)
                }

                Checkbox("Animated", isChecked: $animatedScroll)
                    // FIXME: Binding does not work correctly?
                    .id(animatedScroll ? 1 : 0)

                Button("Scroll to First", size: .small) {
                    scrollProxy.scrollTo(0, animated: animatedScroll)
                }

                Button("Scroll to 2", size: .small) {
                    scrollProxy.scrollTo(2, animated: animatedScroll)
                }

                Button("Scroll to Last", size: .small) {
                    scrollProxy.scrollTo(6, animated: animatedScroll)
                }
            }
        }
        .previewDisplayName()
    }

    @ViewBuilder var tileVariants: some View {
        tile
        largerTile
        expandingWidthTile
        expandingTile
        expandingTileLarger
    }

    var tile: some View {
        Tile("Intrinsic") {
            // No Action
        } content: {
            intrinsicContentPlaceholder
        }
    }

    var largerTile: some View {
        Tile("Intrinsic Larger") {
            // No Action
        } content: {
            VStack(spacing: .xSmall) {
                intrinsicContentPlaceholder
                intrinsicContentPlaceholder
            }
            .padding(.xSmall)
            .background(Color.greenLight)
        }
    }

    var expandingTile: some View {
        Tile("Expanding All") {
            // No Action
        } content: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Top")
                    Spacer(minLength: .medium)
                    Text("Bottom")
                }
                Spacer(minLength: 0)
            }
            .padding(.medium)
            .background(Color.orangeLight)
        }
    }

    var expandingTileLarger: some View {
        Tile("Expanding All Larger") {
            // No Action
        } content: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Top")
                    Text("Top 2")
                    Spacer(minLength: .medium)
                    Text("Bottom")
                    Text("Bottom 2")
                }
                Spacer(minLength: 0)
            }
            .padding(.medium)
            .background(Color.orangeLight)
        }
    }

    var expandingWidthTile: some View {
        Tile("Expanding Width") {
            // No Action
        } content: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: .xSmall) {
                    Text("Top")
                    Text("Bottom")
                }
                Spacer(minLength: 0)
            }
            .padding(.medium)
            .background(Color.orangeLight)
        }
    }
}

struct StorybookHorizontalScrollPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookHorizontalScroll()
        }
    }
}

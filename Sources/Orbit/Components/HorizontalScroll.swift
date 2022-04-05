import SwiftUI

public enum HorizontalScrollItemWidth {
    /// Each item will use its own intrinsic width.
    case intrinsic
    /// Width ratio compared to container width.
    case ratio(CGFloat = 0.8)
    /// Custom fixed width.
    case custom(CGFloat)
}

public enum HorizontalScrollItemHeight {
    /// Each item will use its intrinsic height. If the item is expanding vertically, its height will be capped to tallest item.
    case intrinsic
    /// Custom fixed height.
    case custom(CGFloat)
}

struct HorizontalScrollWidthKey: PreferenceKey {

    static var defaultValue: CGFloat { 10 }

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

/// Groups items onto one accessible row even on small screens.
///
/// Can be used to present similar items (such as cards with baggage options) as a single row even on small screens.
///
/// - Related components:
///   - ``ChoiceTile``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/layout/horizontalscroll/)
public struct HorizontalScroll<Content: View>: View {

    @State private var availableWidth: CGFloat = 0

    let spacing: CGFloat
    let itemWidth: HorizontalScrollItemWidth
    let itemHeight: HorizontalScrollItemHeight
    let maxItemWidth: CGFloat?
    let minHeight: CGFloat?
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let content: () -> Content

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: spacing) {
                content()
                    .frame(width: itemWidth(forContentWidth: availableWidth), alignment: .leading)
                    .frame(maxWidth: maxItemWidth, alignment: .leading)
                    .frame(height: resolvedItemHeight, alignment: .top)

                Strut(height: minHeight)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
        .background(
            GeometryReader { proxy in
                Color.clear.preference(
                    key: HorizontalScrollWidthKey.self,
                    value: proxy.size.width
                )
            }
        )
        .onPreferenceChange(HorizontalScrollWidthKey.self) {
            availableWidth = $0
        }
    }

    var resolvedItemHeight: CGFloat? {
        switch itemHeight {
            case .intrinsic:            return nil
            case .custom(let height):   return height
        }
    }

    /// Creates Orbit HorizontalScroll component.
    /// - Parameters:
    ///   - spacing: Spacing between items. Default value is `.small`.
    ///   - itemWidth: Horizontal sizing style of all items. Default value is `.ratio()`.
    ///   - itemHeight: Horizontal sizing style of all items. Default value is `.intrinsic`.
    ///   - maxItemWidth: Maximal item width that caps the result of ``itemWidth``. Default value is derived from `Layout.readableMaxWidth`.
    ///   - minHeight: Minimal height of component. Default value is `nil`.
    ///   - horizontalPadding: Horizontal padding inside the ScrollView. Default value is `.xSmall`.
    ///   - verticalPadding: Horizontal padding inside the ScrollView. Can be used to fix overlay issues. Default value is `.xSmall`.
    ///   - content: Child items that will be horizontally laid out based on above parameters.
    public init(
        spacing: CGFloat = .small,
        itemWidth: HorizontalScrollItemWidth = .ratio(),
        itemHeight: HorizontalScrollItemHeight = .intrinsic,
        maxItemWidth: CGFloat? = Layout.readableMaxWidth - 270,
        minHeight: CGFloat? = nil,
        horizontalPadding: CGFloat = .xSmall,
        verticalPadding: CGFloat = .xSmall,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.maxItemWidth = maxItemWidth
        self.minHeight = minHeight
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.content = content
    }

    func itemWidth(forContentWidth contentWidth: CGFloat) -> CGFloat? {
        switch itemWidth {
            case .ratio(let ratio):     return min(max(0, ratio * contentWidth - 2 * horizontalPadding), maxItemWidth ?? .infinity)
            case .intrinsic:            return nil
            case .custom(let width):    return min(width, maxItemWidth ?? .infinity)
        }
    }
}

struct HorizontalScrollPreviews: PreviewProvider {

    static var intrinsicContent: some View {
        intrinsicContent {
            customContentPlaceholder
        }
    }

    static func intrinsicContent<Content>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        VStack(alignment: .leading) {
            Text("Text")
            content()
        }
        .border(.red)
    }

    static var previews: some View {
        PreviewWrapper {
            simpleSmallRatio
            simpleCustom
            ratioWidthIntrinsicHeight
            smallRatioWidthIntrinsicHeight
            fullWidthIntrinsicHeight
            intrinsic
            custom
            pagination
                .previewDisplayName("Live Preview - Pagination")
        }
        .previewLayout(.sizeThatFits)
    }

    static var simpleSmallRatio: some View {
        VStack {
            HorizontalScroll(spacing: .large, itemWidth: .ratio(1.01)) {
                Color.blue.frame(height: 10)
                Color.blue.frame(height: 30)
                Color.blue.frame(height: 50)
            }

            HorizontalScroll(spacing: .large, itemWidth: .ratio(1)) {
                Color.blue.frame(height: 10)
                Color.blue.frame(height: 30)
                Color.blue.frame(height: 50)
            }

            HorizontalScroll(spacing: .large, itemWidth: .ratio(0.5)) {
                Color.blue.frame(height: 10)
                Color.blue.frame(height: 30)
                Color.blue.frame(height: 50)
            }

            HorizontalScroll(spacing: .large, itemWidth: .ratio(0.33)) {
                Color.blue.frame(height: 10)
                Color.blue.frame(height: 30)
                Color.blue.frame(height: 50)
                Color.blue.frame(height: 20)
            }
        }
        .background(Color.gray.frame(width: 1).padding(.leading, .xSmall), alignment: .leading)
        .background(Color.gray.frame(width: 1).padding(.trailing, .xSmall), alignment: .trailing)
        .previewDisplayName("W - ratios, H - intrinsic")
    }

    static var simpleCustom: some View {
        HorizontalScroll(itemWidth: .custom(30), itemHeight: .custom(30)) {
            Color.blue
            Color.blue
            Color.blue
        }
        .border(.gray)
        .previewDisplayName("W - custom, H - custom")
    }

    static var ratioWidthIntrinsicHeight: some View {
        HorizontalScroll {
            intrinsicContent

            intrinsicContent {
                Color.blue
                    .frame(width: 100, height: 150)
            }

            intrinsicContent
        }
        .border(.gray)
        .previewDisplayName("W - ratio, H - intrinsic")
    }

    static var smallRatioWidthIntrinsicHeight: some View {
        HorizontalScroll(itemWidth: .ratio(0.3), itemHeight: .intrinsic) {
            intrinsicContent {
                VStack {
                    Text("Matching tallest item using Spacer")
                    Spacer()
                    customContentPlaceholder
                }
            }

            intrinsicContent {
                Color.blue
                    .frame(height: 150)
            }

            intrinsicContent
        }
        .border(.gray)
        .previewDisplayName("W - small ratio, H - intrinsic")
    }

    static var fullWidthIntrinsicHeight: some View {
        HorizontalScroll(itemWidth: .ratio(1), itemHeight: .intrinsic) {
            intrinsicContent

            intrinsicContent {
                Color.blue
                    .frame(height: 150)
            }

            intrinsicContent
        }
        .border(.gray)
        .previewDisplayName("W - full, H - intrinsic")
    }

    static var intrinsic: some View {
        HorizontalScroll(itemWidth: .intrinsic, itemHeight: .intrinsic) {
            intrinsicContent

            intrinsicContent {
                Color.blue
                    .frame(width: 100, height: 150)
            }

            intrinsicContent
        }
        .previewDisplayName("W - intrinsic, H - intrinsic")
    }

    static var custom: some View {
        HorizontalScroll(itemWidth: .custom(100), itemHeight: .custom(130)) {
            intrinsicContent {
                Spacer()
                Color.red
            }

            intrinsicContent {
                Color.red
                Spacer()
                Text("Footer")
            }

            intrinsicContent {
                Text("No Spacer")
            }
        }
        .border(.gray)
        .previewDisplayName("W - custom, H - custom")
    }

    static let scrollUnitPoint = UnitPoint(x: 10, y: 0)

    @ViewBuilder static var pagination: some View {
        if #available(iOS 14, *) {
            ScrollViewReader { scrollProxy in
                VStack(spacing: .medium) {
                    HorizontalScroll {
                        intrinsicContent {
                            Spacer()
                            Color.red
                        }
                        .padding(16)
                        .border(.green)
                        .id(1)

                        intrinsicContent {
                            Color.red
                            Spacer()
                            Text("Footer")
                        }
                        .padding(16)
                        .border(.green)
                        .id(2)

                        intrinsicContent {
                            Text("No Spacer")
                        }
                        .padding(16)
                        .border(.green)
                        .id(3)
                    }
                    .border(.gray)

                    HStack {
                        Button("Scroll to 1", size: .small) {
                            withAnimation {
                                scrollProxy.scrollTo(1, anchor: .topLeading)
                            }
                        }
                        Button("Scroll to 2", size: .small) {
                            withAnimation {
                                scrollProxy.scrollTo(2, anchor: .topLeading)
                            }
                        }
                        Button("Scroll to 3", size: .small) {
                            withAnimation {
                                scrollProxy.scrollTo(3, anchor: .topLeading)
                            }
                        }
                    }
                }
            }

        } else {
            Text("Pagination support only for iOS >= 14")
        }
    }
}

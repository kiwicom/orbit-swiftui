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

/// Groups items onto one accessible row even on small screens.
///
/// Can be used to present similar items (such as cards with baggage options) as a single row even on small screens.
///
/// - Related components:
///   - ``ChoiceTile``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/layout/horizontalscroll/)
public struct HorizontalScroll<Content: View>: View {

    let spacing: CGFloat
    let itemWidth: HorizontalScrollItemWidth
    let itemHeight: HorizontalScrollItemHeight
    let maxItemWidth: CGFloat?
    let minHeight: CGFloat?
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let content: () -> Content

    public var body: some View {
        SingleAxisGeometryReader(axis: .horizontal) { width in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: spacing) {
                    content()
                        .frame(width: itemWidth(forContentWidth: width), alignment: .leading)
                        .frame(maxWidth: maxItemWidth, alignment: .leading)
                        .frame(height: resolvedItemHeight, alignment: .top)
                    
                    Strut(height: minHeight)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
            }
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
            case .ratio(let ratio):     return min(max(0, ratio * (contentWidth - 2 * horizontalPadding)), maxItemWidth ?? .infinity)
            case .intrinsic:            return nil
            case .custom(let width):    return min(width, maxItemWidth ?? .infinity)
        }
    }
}

struct HorizontalScrollPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            simpleSmallRatio
            simpleCustom
            ratioWidthIntrinsicHeight
            smallRatioWidthIntrinsicHeight
            fullWidthIntrinsicHeight
            intrinsic
            custom
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var simpleSmallRatio: some View {
        HorizontalScroll(spacing: .large, itemWidth: .ratio(0.25)) {
            Color.blueNormal.frame(height: 10)
            Color.blueNormal.frame(height: 30)
            Color.blueNormal.frame(height: 50)
        }
        .previewDisplayName("W - small ratio, H - intrinsic")
    }
    
    static var simpleCustom: some View {
        HorizontalScroll(itemWidth: .custom(30), itemHeight: .custom(30)) {
            Color.blueNormal
            Color.blueNormal
            Color.blueNormal
        }
        .previewDisplayName("W - custom, H - custom")
    }
    
    static var ratioWidthIntrinsicHeight: some View {
        HorizontalScroll {

            ChoiceTile("Choice Tile", icon: .accommodation) {
                customContentPlaceholder
            }
            
            ChoiceTile("Choice Tile with long title", icon: .accommodation) {
                Color.blueLight
                    .frame(width: 100, height: 150)
            }
            
            ChoiceTile("Choice Tile", description: "Description", icon: .accommodation) {
                customContentPlaceholder
            }
        }
        .previewDisplayName("W - ratio, H - intrinsic")
    }
    
    static var smallRatioWidthIntrinsicHeight: some View {
        HorizontalScroll(itemWidth: .ratio(0.33), itemHeight: .intrinsic) {

            ChoiceTile("ChoiceTile", icon: .accommodation) {
                VStack {
                    Text("Matching tallest item using Spacer")
                    Spacer()
                    customContentPlaceholder
                }
            }
            
            ChoiceTile("ChoiceTile", icon: .accommodation) {
                Color.blueLight
                    .frame(height: 150)
            }
            
            ChoiceTile("ChoiceTile", description: "Description", icon: .accommodation) {
                customContentPlaceholder
            }
        }
        .previewDisplayName("W - small ratio, H - intrinsic")
    }
    
    static var fullWidthIntrinsicHeight: some View {
        HorizontalScroll(itemWidth: .ratio(1), itemHeight: .intrinsic) {

            ChoiceTile("Choice Tile", icon: .accommodation) {
                customContentPlaceholder
            }
            
            ChoiceTile("Choice Tile with long title", icon: .accommodation) {
                Color.blueLight
                    .frame(height: 150)
            }
            
            ChoiceTile("Choice Tile", description: "Description", icon: .accommodation) {
                customContentPlaceholder
            }
        }
        .previewDisplayName("W - full, H - intrinsic")
    }
    
    static var intrinsic: some View {
        HorizontalScroll(itemWidth: .intrinsic, itemHeight: .intrinsic) {

            ChoiceTile("Choice Tile", icon: .accommodation) {
                customContentPlaceholder
            }
            
            ChoiceTile("Choice Tile with long title", icon: .accommodation) {
                Color.blueLight
                    .frame(height: 150)
            }
            
            ChoiceTile("Choice Tile", description: "Description", icon: .accommodation) {
                customContentPlaceholder
            }
        }
        .previewDisplayName("W - intrinsic, H - intrinsic")
    }
    
    static var custom: some View {
        HorizontalScroll(itemWidth: .custom(120), itemHeight: .custom(120)) {

            ChoiceTile("Choice Tile", icon: .accommodation) {
                Spacer()
            }
            
            ChoiceTile("Choice Tile") {
                Spacer()
                Text("Footer")
            }
            
            ChoiceTile("Choice Tile") {
                Text("Footer")
            }
        }
        .previewDisplayName("W - custom, H - custom")
    }
}

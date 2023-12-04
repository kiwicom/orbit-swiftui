import SwiftUI
import Combine

/// Orbit component that groups items onto one accessible scrollable row. 
/// In contrast to the native horizontal `SwiftUI.ScrollView`, this component offers snapping to item leading edges both manually and programmatically.
///
/// A ``HorizontalScroll`` consists of provided content that will be arranged horizontally with the consistent item width and provided spacing.
///
/// ```swift
/// HorizontalScroll {
///     Tile("Choice 1")
///     Tile("Choice 2")
///     Tile("Choice 3")
/// }
/// ```
///
/// The content can be scrolled programatically when wrapped inside ``HorizontalScrollReader``.
/// 
/// ```swift
/// HorizontalScrollReader { scrollProxy in
///     HorizontalScroll {
///         Tile("Choice 1")
///         Tile("Choice 2")
///         Tile("Choice 3")
///     }
///     
///     Button("Scroll to first choice") {
///         scrollProxy.scrollTo(0)
///     }
/// }
/// ```
///
/// ### Layout
///
/// The component adds `HStack` over the provided content.
/// 
/// Component expands horizontally and has a layout similar to the native `ScrollView` with `horizontal` scrollable axis.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/layout/horizontalscroll/)
public struct HorizontalScroll<Content: View>: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.screenLayoutPadding) private var screenLayoutPadding
    @Environment(\.scrollTarget) private var scrollTarget

    @State private var contentSize: CGSize = .zero
    @State private var scrollingInProgress = false
    @State private var idPreferences: [IDPreference] = []
    @State private var itemCount = 0
    @State private var scrollViewWidth: CGFloat = 0

    @State private var scrollOffset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var lastOffsetDifference: CGFloat?
    @State private var lastDate: Date?
    @State private var isAnimating = false
    @State private var timer = Timer.publish(every: 0.1, on: .current, in: .common)

    // Padding to avoid ScrollView content clipping
    private let clippingPadding: CGFloat = .medium
    private let snapAnimationDuration: CGFloat = 0.8
    private let programaticSnapAnimationDuration: CGFloat = 0.5

    private let spacing: CGFloat
    private let isSnapping: Bool
    private let itemWidth: HorizontalScrollItemWidth
    @ViewBuilder private let content: Content

    public var body: some View {
        scrollViewContent
            .background(availableWidthReader)
            .frame(height: contentSize.height, alignment: .top)
            .onPreferenceChange(ScrollViewWidthPreferenceKey.self) {
                scrollViewWidth = $0
            }
            .clipped()
            .padding(-clippingPadding)
    }

    @ViewBuilder private var scrollViewContent: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: spacing) {
                content
                    // Adjust item sizes if required
                    .frame(width: resolvedItemWidth, alignment: .leading)
                    .highPriorityGesture(
                        // Required to cancel tap gesture during scrolling
                        DragGesture()
                    )
            }
            .onPreferenceChange(ChildCountPreferenceKey.self) {
                itemCount = $0
            }
            .padding(clippingPadding)
            // Vertically cap height to tallest item
            // and prevent horizontal spacing resizing
            .fixedSize()
            .allowsHitTesting(isIdle)
            .background(contentHeightReader)
            .offset(x: scrollOffset)
            .background(
                Color.clear
                    .preference(key: HorizontalScrollOffsetPreferenceKey.self, value: scrollOffset)
            )
            .contentShape(Rectangle())
            .valueChanged(scrollTarget) { scrollTarget in
                guard let scrollTarget else {
                    return
                }
                scrollTo(id: scrollTarget.id, geometry: geometry, animated: scrollTarget.animated)
            }
            .onReceive(timer) { output in
                guard let lastDate else { return }
                let animatingTime = output.timeIntervalSince(lastDate)
                animateOffset(currentTime: animatingTime)
            }
            .onPreferenceChange(ContentSizePreferenceKey.self) {
                contentSize = $0
            }
            .onPreferenceChange(IDPreferenceKey.self) {
                idPreferences = $0
            }
            .simultaneousGesture(
                SimultaneousGesture(scrollingGesture, scrollStoppingGesture)
            )
        }
    }

    @ViewBuilder private var contentHeightReader: some View {
        GeometryReader { geometry in
            Color.clear.preference(
                key: ContentSizePreferenceKey.self,
                value: geometry.size
            )
        }
    }

    @ViewBuilder private var availableWidthReader: some View {
        SingleAxisGeometryReader(axis: .horizontal) { width in
            Color.clear.preference(key: ScrollViewWidthPreferenceKey.self, value: width)
        }
    }

    private var isIdle: Bool {
        (scrollingInProgress || isAnimating) == false
    }

    private var screenLayoutHorizontalPadding: CGFloat {
        guard let screenLayoutPadding = screenLayoutPadding else {
            return spacing
        }

        return screenLayoutPadding.horizontal(horizontalSizeClass: horizontalSizeClass)
    }

    private var scrollingGesture: some Gesture {
        DragGesture(minimumDistance: .xxxSmall)
            .onChanged { gesture in
                updateOffset(gesture: gesture)
            }
            .onEnded { gesture in
                gestureEnded(gesture: gesture)
            }
    }

    private var scrollStoppingGesture: some Gesture {
        TapGesture()
            .onEnded {
                stopSnappingAnimation()
            }
    }

    private var isContentBiggerThanScrollView: Bool {
        contentSize.width > scrollViewWidth
    }

    private var maxOffset: CGFloat {
        -contentSize.width + scrollViewWidth
    }

    private var resolvedItemWidth: CGFloat {
        switch itemWidth {
            case .ratio(let ratio, let maxWidth):
                let ratio = max(0.05, ratio)
                return min(
                    max(0, ratio * (scrollViewWidth - (-1 + 1 / ratio) * spacing - screenLayoutHorizontalPadding * 2)),
                    maxWidth ?? .infinity
                )
            case .fixed(let width):
                return width
        }
    }

    private func scrollTo(id: AnyHashable, geometry: GeometryProxy, animated: Bool) {
        guard let preferenceIndex = idPreferences.firstIndex(where: { $0.id == id }) else {
            return
        }

        let itemToScrollTo = idPreferences[preferenceIndex]
        let minX = geometry[itemToScrollTo.bounds].minX
        let paddingOffset = preferenceIndex < itemCount - 2 ? screenLayoutHorizontalPadding : 0
        let offset = offsetInBounds(offset: -minX + scrollOffset) + paddingOffset

        if animated {
            withAnimation(.easeOut(duration: programaticSnapAnimationDuration)) {
                scrollOffset = offset
            }
        } else {
            scrollOffset = offset
        }

        lastOffset = scrollOffset
    }

    private func animateOffset(currentTime: TimeInterval) {
        guard let lastOffsetDifference, currentTime < snapAnimationDuration else {
            return stopSnappingAnimation()
        }

        let progress = currentTime / snapAnimationDuration
        let progressWithAnimationCurve = 1 - pow(1 - progress, 3)
        let translation = lastOffsetDifference * progressWithAnimationCurve

        let currentOffset = translation + lastOffset
        let maxOffset = -contentSize.width + scrollViewWidth
        let isContentBiggerThanScrollView = contentSize.width > scrollViewWidth

        guard isContentBiggerThanScrollView else { return }

        if currentOffset > scrollViewWidth / 5 {
            stopSnappingAnimation()
        } else if currentOffset < maxOffset - scrollViewWidth / 5 {
            stopSnappingAnimation()
        } else {
            scrollOffset = scrollSnappingOffset(currentOffset: currentOffset)
        }
    }

    private func scrollSnappingOffset(currentOffset: CGFloat) -> CGFloat {
        if currentOffset > 0 {
            return adjustedSnappingOffsetOverBounds(offsetOverBounds: currentOffset)
        } else if currentOffset < maxOffset {
            return maxOffset - adjustedSnappingOffsetOverBounds(offsetOverBounds: abs(currentOffset - maxOffset))
        } else {
            return currentOffset
        }
    }

    private func stopSnappingAnimation() {
        withAnimation(.spring()) {
            scrollOffset = offsetInBounds(offset: scrollOffset)
        }
        isAnimating = false
        timer.connect().cancel()
        lastOffset = scrollOffset
    }

    private func updateOffset(gesture: DragGesture.Value) {
        if scrollingInProgress == false {
            stopSnappingAnimation()
        }

        guard isContentBiggerThanScrollView else { return }

        scrollingInProgress = true
        scrollOffset = scrollSnappingOffset(currentOffset: gesture.translation.width + lastOffset)
    }

    private func gestureEnded(gesture: DragGesture.Value) {
        scrollingInProgress = false

        guard isContentBiggerThanScrollView else { return }

        let modifiedOffset = offsetToSnap(gesture: gesture)
        let offsetDifference = modifiedOffset - gesture.translation.width - lastOffset
        lastOffsetDifference = offsetDifference

        if let lastDate,
           Date().timeIntervalSince(lastDate) > snapAnimationDuration,
           abs(offsetDifference) < resolvedItemWidth {
            lastOffset = modifiedOffset
            withAnimation(.spring()) {
                scrollOffset = offsetInBounds(offset: modifiedOffset)
            }
            return
        }

        lastDate = Date()
        lastOffset += gesture.translation.width
        startAnimation()
    }

    private func offsetToSnap(gesture: DragGesture.Value) -> CGFloat {
        let expectedOffset = gesture.predictedEndTranslation.width + lastOffset
        let velocity = gesture.predictedEndLocation.x - gesture.location.x

        let itemWidth = resolvedItemWidth
        let itemWidthWithSpacing = itemWidth + spacing

        let index = (expectedOffset + itemWidth / 2) / -itemWidthWithSpacing
        let indexToScrollTo = ceil(index)

        guard isSnapping else {
            let absVelocity = abs(velocity)
            let sign: CGFloat = velocity > 0 ? 1 : -1
            return expectedOffset + sign * max(0, absVelocity - 100) / 2
        }

        return -(indexToScrollTo * itemWidthWithSpacing)
    }

    // Reduces the offset acceleration the further the item is from the edge
    private func adjustedSnappingOffsetOverBounds(offsetOverBounds: CGFloat) -> CGFloat {
        guard scrollViewWidth != 0 else { return 0 }
        let normalizedTransition = offsetOverBounds / scrollViewWidth
        let logValue = log(1 + abs(normalizedTransition))
        return scrollViewWidth / 2 * logValue
    }

    private func startAnimation() {
        timer = Timer.publish(every: 1 / 60, on: .current, in: .common)
        _ = timer.connect()
        isAnimating = true
    }

    private func offsetInBounds(offset: CGFloat) -> CGFloat {
        min(
            max(
                -contentSize.width + scrollViewWidth,
                offset
            ),
            .zero
        )
    }
}

// MARK: - Inits
public extension HorizontalScroll {

    /// Creates Orbit ``HorizontalScroll`` component.
    ///
    /// - Parameters:
    ///   - isSnapping: Specifies whether the scrolling should snap items to their leading edge.
    ///   - spacing: Spacing between items.
    ///   - itemWidth: Horizontal sizing of each item.
    ///   - content: Items that will be arranged horizontally based on above parameters.
    init(
        isSnapping: Bool = true,
        spacing: CGFloat = .small,
        itemWidth: HorizontalScrollItemWidth = .ratio(),
        @ViewBuilder content: () -> Content
    ) {
        self.isSnapping = isSnapping
        self.spacing = spacing
        self.itemWidth = itemWidth
        self.content = content()
    }
}

// MARK: - Types

/// Width for all items used in Orbit ``HorizontalScroll``.
public enum HorizontalScrollItemWidth {
    /// Width ratio calculated from the available container width.
    case ratio(CGFloat = 0.48, maxWidth: CGFloat? = Layout.readableMaxWidth - 270)
    /// Custom fixed width.
    case fixed(CGFloat)
}

// MARK: - Preference keys

private struct ScrollViewWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value _: inout CGFloat, nextValue _: () -> CGFloat) { /* Take first value */ }
}

private struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) { /* Take first value */ }
}

struct HorizontalScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        if value != nil {
            // Allow nested hierarchies by not overwriting the value
            // in case it is already set
            return
        }

        let nextValue = nextValue()

        // Avoid rewriting the value by unrelated component in the hierarchy
        if nextValue != nil {
            value = nextValue
        }
    }
}

// MARK: - Previews
struct HorizontalScrollPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            ratio
            fixed
            fitting
            insideCards
        }
        .screenLayout()
        .background(Color.screen)
        .previewLayout(.sizeThatFits)
    }

    static var ratio: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Heading("Snapping", style: .title4)

            HorizontalScroll(spacing: .medium) {
                tileVariants
            }

            Heading("No snapping", style: .title4)

            HorizontalScroll(isSnapping: false, spacing: .medium) {
                tileVariants
            }
        }
        .previewDisplayName()
    }

    static var fixed: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Heading("Snapping", style: .title4)

            HorizontalScroll(isSnapping: true, spacing: .medium, itemWidth: .fixed(180)) {
                tileVariants
            }

            Heading("No snapping", style: .title4)

            HorizontalScroll(isSnapping: false, spacing: .medium, itemWidth: .fixed(180)) {
                tileVariants
            }
        }
        .previewDisplayName()
    }

    static var fitting: some View {
        VStack(alignment: .leading, spacing: .medium) {
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

    static var insideCards: some View {
        VStack(alignment: .leading, spacing: .medium) {
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

    @ViewBuilder static var tileVariants: some View {
        tile
        largerTile
        expandingWidthTile
        expandingTile
        expandingTileLarger
    }

    static var tile: some View {
        Tile("Intrinsic") {
            // No Action
        } content: {
            intrinsicContentPlaceholder
        }
    }

    static var largerTile: some View {
        StateWrapper(true) { isSelected in
            ChoiceTile("Intrinsic Larger", isSelected: isSelected.wrappedValue) {
                isSelected.wrappedValue.toggle()
            } content: {
                VStack(spacing: .xSmall) {
                    intrinsicContentPlaceholder
                    intrinsicContentPlaceholder
                }
                .padding(.xSmall)
                .background(Color.greenLight)
            }
        }
    }

    static var expandingTile: some View {
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

    static var expandingTileLarger: some View {
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

    static var expandingWidthTile: some View {
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

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .medium) {
            ratio
            fixed
        }
        .screenLayout()
    }
}

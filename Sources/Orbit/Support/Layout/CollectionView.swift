//  Created by Chris Eidhof on 02.02.21.
import SwiftUI

/*
 To calculate a flow layout, we need the sizes of the collection's elements.
 The "easiest" way to do this seems to be using preference keys:
 these are values that a child view can set and that get propagated up in the view hierarchy.

 A preference key consists of two parts: a type for the data (this needs to be equatable) and a type for the key itself.
 */

struct SizePreferenceKeyData: Equatable {
    var size: CGSize
    var id: AnyHashable
}

struct SizesPreferenceKey: PreferenceKey {
    typealias Value = [SizePreferenceKeyData]

    static var defaultValue: [SizePreferenceKeyData] = []

    static func reduce(value: inout [SizePreferenceKeyData], nextValue: () -> [SizePreferenceKeyData]) {
        value.append(contentsOf: nextValue())
    }
}

// Next up, we create a wrapper view which renders it's content view,
// but also propagates its size up the view hierarchy using the preference key.
struct PropagatesSize<ID: Hashable, V: View>: View {
    var id: ID
    var content: V

    var body: some View {
        content
            .fixedSize()
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: SizesPreferenceKey.self,
                        value: [SizePreferenceKeyData(size: proxy.size, id: AnyHashable(self.id))]
                    )
                }
            )
    }
}

struct FlowLayout {
    let spacing: UIOffset
    let containerSize: CGSize

    init(containerSize: CGSize, spacing: UIOffset = UIOffset(horizontal: 10, vertical: 10)) {
        self.spacing = spacing
        self.containerSize = containerSize
        self.width = containerSize.width
    }

    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var lineHeight: CGFloat = 0
    var width: CGFloat

    mutating func add(element size: CGSize) -> CGRect {
        if currentX + size.width > containerSize.width {
            currentX = 0
            width = max(width, size.width)
            currentY += lineHeight + spacing.vertical
        }
        defer {
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing.horizontal
        }
        return CGRect(origin: CGPoint(x: currentX, y: currentY), size: size)
    }

    var size: CGSize {
        CGSize(width: width, height: currentY + lineHeight)
    }
}

/*
 Finally, here's the collection view. It works as following:

 It contains a collection of `Data` and a way to construct `Content` from an element of `Data`.
 For each value of `Data`, it wraps the element in a `PropagatesSize` container, and then collects
 all those sizes to construct the layout.
 */

struct OverallHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat = 10
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// A view that wraps content in multiline flow layout.
struct CollectionView<Data, Content>:
View where Data: RandomAccessCollection, Data.Index: Hashable, Data.Element: Identifiable, Content: View {

    @State private var sizes: [SizePreferenceKeyData] = []
    @State private var height: CGFloat = 10

    var data: Data
    var spacing: UIOffset
    var content: (Data.Index) -> Content

    func layout(size: CGSize) -> (items: [AnyHashable: CGSize], size: CGSize) {
        var flowLayout = FlowLayout(containerSize: size, spacing: spacing)
        var result: [AnyHashable: CGSize] = [:]
        for size in sizes {
            let rect = flowLayout.add(element: size.size)
            result[size.id] = CGSize(width: rect.origin.x, height: rect.origin.y)
        }
        return (result, flowLayout.size)
    }

    func withLayout(_ laidout: (items: [AnyHashable: CGSize], size: CGSize)) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(data.indices, id: \.self) { index in
                PropagatesSize(id: data[index].id, content: content(index))
                    .offset(laidout.items[AnyHashable(data[index].id)] ?? .zero)
            }
            .preference(key: OverallHeightPreference.self, value: laidout.size.height)
        }
        .onPreferenceChange(SizesPreferenceKey.self, perform: {
            sizes = $0
        })
        .onPreferenceChange(OverallHeightPreference.self, perform: { value in
            height = value
        })
    }

    var body: some View {
        if #available(iOS 14.0, *) {
            GeometryReader { proxy in
                withLayout(layout(size: proxy.size))
            }
            .frame(height: height)
        } else {
            // Fix different iOS13 center alignment geometryReader implementation
            GeometryReader { proxy in
                withLayout(layout(size: proxy.size))
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
            }
            .frame(height: height)
        }
    }
}

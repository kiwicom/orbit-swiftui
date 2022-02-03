import SwiftUI

/// A geometry reader for a single specific axis.
///
/// Avoids issues with infinitely growing geometry reader that grows in both axis.
public struct SingleAxisGeometryReader<Content: View>: View {

    private struct SizeKey: PreferenceKey {

        static var defaultValue: CGFloat {
            10
        }

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }

    @State private var size: CGFloat = SizeKey.defaultValue

    private var axis: Axis = .horizontal
    private var alignment: Alignment = .center
    private let content: (CGFloat) -> Content

    public var body: some View {
        content(size)
            .frame(
                maxWidth: axis == .horizontal ? .infinity : nil,
                maxHeight: axis == .vertical ? .infinity : nil,
                alignment: alignment
            )
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: SizeKey.self,
                        value: axis == .horizontal ? proxy.size.width : proxy.size.height
                    )
                }
            )
            .onPreferenceChange(SizeKey.self) {
                size = $0
            }
    }

    public init(axis: Axis = .horizontal, alignment: Alignment = .center, content: @escaping (CGFloat) -> Content) {
        self.axis = axis
        self.alignment = alignment
        self.content = content
    }
}

import SwiftUI

/// A geometry reader for a specific axis. Unlike GeometryReader, it does not expand to infinity in the other axis.
public struct SingleAxisGeometryReader<Content: View>: View {

    @State private var size: CGFloat = SizePreferenceKey.defaultValue

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
                        key: SizePreferenceKey.self,
                        value: axis == .horizontal ? proxy.size.width : proxy.size.height
                    )
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) {
                size = $0
            }
    }

    public init(axis: Axis = .horizontal, alignment: Alignment = .center, content: @escaping (CGFloat) -> Content) {
        self.axis = axis
        self.alignment = alignment
        self.content = content
    }
}

// MARK: - Previews
struct SingleAxisGeometryReaderPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            SingleAxisGeometryReader(axis: .horizontal) { width in
                Color.blueLight
                    .frame(width: 200, height: 200)
                    .overlay(
                        Text("Available width: \(width)")
                    )
            }

            SingleAxisGeometryReader(axis: .vertical) { height in
                Color.blueLight
                    .frame(width: 200, height: 200)
                    .overlay(
                        Text("Available height: \(height)")
                    )
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

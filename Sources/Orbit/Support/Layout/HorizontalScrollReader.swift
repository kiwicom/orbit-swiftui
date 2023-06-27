import SwiftUI

@available(iOS 14, *)
public class HorizontalScrollViewProxy: ObservableObject {

    @Published fileprivate var scrollTarget: ScrollTargetValue?

    public func scrollTo(_ id: some Hashable, animated: Bool = true) {
        scrollTarget = .init(id: id, animated: animated)
    }
}

/// A view that provides programmatic scrolling of `HorizontalScroll` component,
/// by working with a proxy to scroll to child views marked by `identifier()`.
@available(iOS 14, *)
public struct HorizontalScrollReader<Content: View>: View {

    @ViewBuilder let content: (HorizontalScrollViewProxy) -> Content

    @StateObject private var proxy = HorizontalScrollViewProxy()

    public var body: some View {
        content(proxy)
            .onPreferenceChange(HorizontalScrollOffsetPreferenceKey.self) { _ in
                // Reset scroll target after scroll offset change
                proxy.scrollTarget = nil
            }
            .environment(\.scrollTarget, proxy.scrollTarget)
    }

    public init(@ViewBuilder content: @escaping (HorizontalScrollViewProxy) -> Content) {
        self.content = content
    }
}

struct ScrollTargetValue: Equatable {
    let id: AnyHashable
    let animated: Bool
}

struct ScrollTargetKey: EnvironmentKey {
    static let defaultValue: ScrollTargetValue? = nil
}

extension EnvironmentValues {

    var scrollTarget: ScrollTargetValue? {
        get { self[ScrollTargetKey.self] }
        set { self[ScrollTargetKey.self] = newValue }
    }
}

// MARK: - Previews
@available(iOS 14, *)
struct HorizontalScrollReaderPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .screenLayout()
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var standalone: some View {
        StateWrapper((false, false)) { state in
            HorizontalScrollReader { scrollProxy in
                VStack(alignment: .leading, spacing: .medium) {
                    HorizontalScroll(isSnapping: state.wrappedValue.0) {
                        HorizontalScrollPreviews.tile
                            .identifier(0)

                        ForEach(1..<5) { index in
                            Tile("Tile \(index)", description: "Tap to scroll to previous") {
                                scrollProxy.scrollTo(index - 1, animated: state.wrappedValue.1)
                            }
                            .identifier(index)
                        }

                        HorizontalScrollPreviews.largerTile
                            .identifier(5)

                        HorizontalScrollPreviews.expandingWidthTile
                            .identifier(6)
                    }

                    Checkbox("Snapping", isChecked: state.0)
                    // FIXME: Binding does not work correctly?
                        .id(state.wrappedValue.0 ? 1 : 0)

                    Checkbox("Animated", isChecked: state.1)
                    // FIXME: Binding does not work correctly?
                        .id(state.wrappedValue.1 ? 1 : 0)

                    Button("Scroll to First") {
                        scrollProxy.scrollTo(0, animated: state.wrappedValue.1)
                    }

                    Button("Scroll to 2") {
                        scrollProxy.scrollTo(2, animated: state.wrappedValue.1)
                    }

                    Button("Scroll to Last") {
                        scrollProxy.scrollTo(6, animated: state.wrappedValue.1)
                    }
                }
            }
        }
    }
}

import SwiftUI

/// A proxy for Orbit ``HorizontalScrollReader``.
@available(iOS 14, *)
public class HorizontalScrollViewProxy: ObservableObject {

    @Published fileprivate var scrollTarget: ScrollTargetValue?

    /// Attempts to scroll to the item marked by Orbit ``identifier(_:)``.
    /// 
    /// - Important: Animated variant may not be reliable when used in a quick succession.
    public func scrollTo(_ id: some Hashable, animated: Bool = true) {
        scrollTarget = .init(id: id, animated: animated)
    }
}

/// Orbit component that provides programmatic scrolling of ``HorizontalScroll`` component,
/// by working with a ``HorizontalScrollViewProxy`` to scroll to child views marked by Orbit ``identifier(_:)`` modifier.
/// 
/// A  ``horizontalScrollPosition(id:)`` can be used instead for a bidirectional management of currently scrolled item.
@available(iOS 14, *)
@available(iOS, obsoleted: 17.0, message: "Prefer using the native `ScrollViewReader`")
public struct HorizontalScrollReader<Content: View>: View {

    @StateObject private var proxy = HorizontalScrollViewProxy()
    @ViewBuilder private let content: (HorizontalScrollViewProxy) -> Content

    public var body: some View {
        content(proxy)
            .onPreferenceChange(HorizontalScrollOffsetPreferenceKey.self) { _ in
                // Reset scroll target after scroll offset change
                proxy.scrollTarget = nil
            }
            .environment(\.scrollTarget, proxy.scrollTarget)
    }

    /// Creates Orbit ``HorizontalScrollReader`` component.
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
                            .overlay(TimelineIndicator(), alignment: .topTrailing)
                            .identifier(index)
                        }

                        HorizontalScrollPreviews.largerTile
                            .identifier(5)

                        HorizontalScrollPreviews.expandingWidthTile
                            .identifier(6)
                    }

                    Checkbox("Snapping", isChecked: state.0)
                        .id(state.wrappedValue.0 ? 1 : 0)

                    Checkbox("Animated", isChecked: state.1)
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

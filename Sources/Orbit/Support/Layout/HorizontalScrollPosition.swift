import SwiftUI

@available(iOS 14, *)
struct HorizontalScrollPositionModifier: ViewModifier {

    @Binding var position: AnyHashable
    let animated: Bool
    
    @State private var isModified = false
    
    func body(content: Content) -> some View {
        HorizontalScrollReader { proxy in
            content
                .onChange(of: position) { newValue in
                    if isModified {
                        isModified = false
                        return
                    }
                    proxy.scrollTo(newValue, animated: animated)
                }
                .onPreferenceChange(HorizontalScrollScrolledItemIDKey.self) { value in
                    if position != value {
                        isModified = true
                        position = value
                    }
                }
        }
    }
}

public extension View {

    /// Associates a binding to be updated when an Orbit ``HorizontalScroll`` view within this view scrolls.
    /// 
    /// Use this modifier along with the ``identifier(_:)`` and ``HorizontalScroll`` to know the identity of the view that is actively scrolled. As the scroll view scrolls, the binding will be updated with the identity of the leading-most / top-most view.
    /// 
    /// You can also write to the binding to scroll to the view with the provided identity.
    /// 
    /// - Important: Animated variant may not be reliable when used in a quick succession.
    @available(iOS 14, *)
    @available(iOS, deprecated: 17.0, message: "Prefer using the native `ScrollView` with `scrollPosition`")
    func horizontalScrollPosition<Value>(id: Binding<Value>, animated: Bool = true) -> some View where Value: Hashable {
        modifier(
            HorizontalScrollPositionModifier(
                position: .init {
                    id.wrappedValue
                } set: {
                    if let value = $0 as? Value {
                        id.wrappedValue = value
                    }
                },
                animated: animated
            )
        )
    }
}

// MARK: - Previews
@available(iOS 14, *)
struct HorizontalScrollPositionModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            StateWrapper(0) { $id in
                VStack(alignment: .leading, spacing: .medium) {
                    Text("Current scroll index \(id)")
                    
                    Heading("Snapping", style: .title3)
                    
                    HorizontalScroll(spacing: .medium, itemWidth: .ratio(0.95)) {
                        ForEach(0..<5) { index in
                            Tile("Tile \(index)", description: "Tap to scroll to previous") {
                                id = index - 1
                            }
                            .identifier(index)
                        }
                    }
                    .horizontalScrollPosition(id: $id)
                    
                    Heading("No snapping, no animation", style: .title3)
                    
                    HorizontalScroll(isSnapping: false, spacing: .medium, itemWidth: .ratio(0.95)) {
                        ForEach(0..<5) { index in
                            Tile("Tile \(index)", description: "Tap to scroll to previous") {
                                id = index - 1
                            }
                            .identifier(index)
                        }
                    }
                    .horizontalScrollPosition(id: $id, animated: false)
                    
                    Heading("Scroll to:", style: .title3)
                    
                    HStack {
                        ForEach(0..<5) { index in
                            Button("\(index)") {
                                id = index
                            }
                        }
                    }
                }
                .screenLayout()
                .onAppear {
                    id = 2
                }
            }
        }
    }
}

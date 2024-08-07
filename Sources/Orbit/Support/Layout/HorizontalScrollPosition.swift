import SwiftUI

@available(iOS 14, *)
struct HorizontalScrollPositionModifier: ViewModifier {

    @Binding var position: AnyHashable
    @State private var isModified = false
    
    func body(content: Content) -> some View {
        HorizontalScrollReader { proxy in
            content
                .onChange(of: position) {
                    if isModified {
                        isModified = false
                        return
                    }
                    proxy.scrollTo($0)
                }
                .onPreferenceChange(HorizontalScrollScrolledItemIDKey.self) {
                    isModified = true
                    position = $0
                }
        }
    }
}

public extension View {

    /// Associates a binding to be updated when an Orbit HorizontalScroll view within this view scrolls.
    /// 
    /// Use this modifier along with the ``identifier(_:)`` and ``HorizontalScroll`` to know the identity of the view that is actively scrolled. As the scroll view scrolls, the binding will be updated with the identity of the leading-most / top-most view.
    /// 
    /// You can also write to the binding to scroll to the view with the provided identity.
    @available(iOS 14, *)
    func horizontalScrollPosition<Value>(id: Binding<Value>) -> some View where Value: Hashable {
        modifier(
            HorizontalScrollPositionModifier(
                position: .init {
                    id.wrappedValue
                } set: {
                    if let value = $0 as? Value {
                        id.wrappedValue = value
                    }
                }
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
                    
                    Heading("Non snapping", style: .title3)
                    
                    HorizontalScroll(isSnapping: false, spacing: .medium, itemWidth: .ratio(0.95)) {
                        ForEach(0..<5) { index in
                            Tile("Tile \(index)", description: "Tap to scroll to previous") {
                                id = index - 1
                            }
                            .identifier(index)
                        }
                    }
                    .horizontalScrollPosition(id: $id)
                    
                    Text("Scrolled item index: \(id ?? -1)")
                    
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
            }
        }
    }
}

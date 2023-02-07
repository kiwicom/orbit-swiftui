import SwiftUI

/// A view that provides a binding to its content.
///
/// This binding can either be supplied, in which case it is used directly,
/// or one is derived from internal state (starting with `defaultValue`).
///
/// This is is useful for components that can manage their own state,
/// but we also want to make it possible for that state to be driven
/// from the outside if a binding is passed.
struct BindingSource<Value, Content: View>: View {

    let outer: Binding<Value>?
    @State var inner: Value
    let content: (Binding<Value>) -> Content

    var body: some View {
        content(outer ?? $inner)
    }

    init(
        _ binding: Binding<Value>?,
        fallbackInitialValue: Value,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self.outer = binding
        self._inner = State(wrappedValue: fallbackInitialValue)
        self.content = content
    }
}

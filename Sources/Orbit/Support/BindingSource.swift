import SwiftUI

/// A binding source for the ``OptionalBinding``.
public enum OptionalBindingSource<Value> {
    case binding(Binding<Value>)
    case state(Value)
}

extension OptionalBindingSource: Sendable where Value: Sendable {}

/// A view that provides either a binding to its content or an internal state, based on provided ``OptionalBindingSource`` value.
///
/// The binding can either be supplied, in which case it is used directly,
/// or one is derived from internal state.
///
/// This is is useful for components that need to manage their own state,
/// but also allow that state to be overridden 
/// using the binding provided from the outside.
public struct OptionalBinding<Value, Content: View>: View {
    
    let binding: Binding<Value>?
    @State var state: Value
    let content: (Binding<Value>) -> Content

    public var body: some View {
        content(binding ?? $state)
    }

    /// Create a view with either a binding to its content or an internal state.
    public init(
        _ source: OptionalBindingSource<Value>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        switch source {
            case .binding(let binding):     
                self.binding = binding
                self._state = .init(wrappedValue: binding.wrappedValue)
            case .state(let value): 
                self.binding = nil
                self._state = State(wrappedValue: value)
        }
     
        self.content = content
    }
}

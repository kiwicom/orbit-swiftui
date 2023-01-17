import SwiftUI

/// Wrapper for state based preview content.
@available(iOS 14.0, *)
public struct StateObjectWrapper<State: ObservableObject, Content: View>: View {

    @StateObject public var state: State
    private var content: (_ state: State) -> Content

    public init(_ initialState: State, @ViewBuilder content: @escaping (_ state: State) -> Content) {
        self.content = content
        self._state = StateObject(wrappedValue: initialState)
    }

    public var body: some View {
        content(state)
    }
}

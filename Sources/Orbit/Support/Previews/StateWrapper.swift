import SwiftUI

/// Wrapper for state based preview content.
public struct StateWrapper<StateT, Content: View>: View {

    @State public var state: StateT
    private var content: (_ binding: Binding<StateT>) -> Content

    public init(initialState: StateT, @ViewBuilder content: @escaping (_ binding: Binding<StateT>) -> Content) {
        self.content = content
        self._state = State(initialValue: initialState)
    }

    public var body: some View {
        content($state)
    }
}

import SwiftUI

/// Wrapper for preview content with Orbit fonts applied.
public struct PreviewWrapper<Content: View>: View {

    var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        Font.registerOrbitFonts()
        self.content = content
    }

    public var body: some View {
        content()
    }
}

/// Wrapper for state based preview content with Orbit fonts applied.
public struct PreviewWrapperWithState<StateT, Content: View>: View {

    @State public var state: StateT
    private var content: (_ binding: Binding<StateT>) -> Content

    public init(initialState: StateT, @ViewBuilder content: @escaping (_ binding: Binding<StateT>) -> Content) {
        Font.registerOrbitFonts()
        self.content = content
        self._state = State(initialValue: initialState)
    }

    public var body: some View {
        content($state)
    }
}

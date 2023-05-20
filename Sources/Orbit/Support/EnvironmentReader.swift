import SwiftUI

/// A view that reads the given environment value value and makes it available to the content.
struct EnvironmentReader<Value, Content: View>: View  {

    @Environment var value: Value
    let content: (Value) -> Content

    init(_ keyPath: KeyPath<EnvironmentValues, Value>, content: @escaping (Value) -> Content) {
        self._value = Environment(keyPath)
        self.content = content
    }

    var body: some View {
        content(value)
    }
}

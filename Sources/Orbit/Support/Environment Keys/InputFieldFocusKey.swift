import SwiftUI

struct InputFieldFocus {
    let binding: Binding<AnyHashable?>
}

struct InputFieldFocusKey: EnvironmentKey {
    static var defaultValue: InputFieldFocus?
}

extension EnvironmentValues {

    var inputFieldFocus: InputFieldFocus? {
        get { self[InputFieldFocusKey.self] }
        set { self[InputFieldFocusKey.self] = newValue }
    }
}

public extension View {

    /// Assigns a focus binding to Orbit text fields in a view.
    ///
    /// When a value of a binding matches the `identifier` of a specific Orbit text field, that text field becomes focused.
    func inputFieldFocus<Value>(_ binding: Binding<Value?>) -> some View where Value: Hashable {
        environment(
            \.inputFieldFocus,
            .init(
                binding: .init(
                    get: { binding.wrappedValue as AnyHashable? },
                    set: { binding.wrappedValue = $0 as? Value }
                )
            )
        )
    }
}

import SwiftUI

struct IdentifierKey: EnvironmentKey {
    static let defaultValue: AnyHashable? = nil
}

public extension EnvironmentValues {

    /// An Orbit identifier stored in a view’s environment.
    var identifier: AnyHashable? {
        get { self[IdentifierKey.self] }
        set { self[IdentifierKey.self] = newValue }
    }
}

public extension View {

    /// Binds a view’s identity to the given proxy value.
    ///
    /// This Orbit override adds the custom `IDPreferenceKey` preference and `identifier` environment value on top of native identity.
    /// This `identifier` is a necessary property of components that are used in some Orbit components or modifiers.
    func identifier<ID: Hashable>(_ id: ID) -> some View {
        self
            .environment(\.identifier, id)
            .id(id)
            .anchorPreference(key: IDPreferenceKey.self, value: .bounds) { bounds in
                [IDPreference(id: id, bounds: bounds)]
            }
    }
}

public struct IDPreferenceKey: PreferenceKey {
    public typealias Value = [IDPreference]

    public static var defaultValue: Value = []

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

public struct IDPreference: Equatable {
    let id: AnyHashable
    let bounds: Anchor<CGRect>

    /// Create Orbit `IDPreference`.
    public init(id: AnyHashable, bounds: Anchor<CGRect>) {
        self.id = id
        self.bounds = bounds
    }
    
    // `Anchor` is only conditionally `Equatable` since iOS 15.
    // If synthesized, the compiler doesn't see any issues and this leads to a runtime crash on earlier iOS versions.
    // That's why this is written here explicitly.
    public static func == (lhs: IDPreference, rhs: IDPreference) -> Bool {
        if #available(iOS 15, *) {
            return lhs.id == rhs.id && lhs.bounds == rhs.bounds
        } else {
            return lhs.id == rhs.id
        }
    }
}

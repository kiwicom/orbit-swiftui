import SwiftUI

struct ShowsSeparatorKey: EnvironmentKey {
    static let defaultValue = true
}

public extension EnvironmentValues {

    /// A separator visibility stored in a view’s environment, used for list-like Orbit components, such as ``ListChoice`` or ``TileGroup``.
    var showsSeparator: Bool {
        get { self[ShowsSeparatorKey.self] }
        set { self[ShowsSeparatorKey.self] = newValue }
    }
}

public extension View {

    /// Set the visibility of separators for Orbit components within the view hierarchy.
    /// 
    /// A counterpart of the native `listRowSeparator()` modifier.
    ///
    /// - Parameters:
    ///   - isVisible: A value that will be used to decide whether Orbit components
    ///   such as ``ListChoice`` or ``TileGroup`` show separators between items.
    func showsSeparator(_ isVisible: Bool = true) -> some View {
        environment(\.showsSeparator, isVisible)
    }
}

import SwiftUI

struct ShowSeparatorKey: EnvironmentKey {
    static let defaultValue = true
}

public extension EnvironmentValues {

    /// A separator visibility stored in a view’s environment, used for list-like Orbit components, such as ``ListChoice`` or ``TileGroup``.
    var showSeparator: Bool {
        get { self[ShowSeparatorKey.self] }
        set { self[ShowSeparatorKey.self] = newValue }
    }
}

public extension View {

    /// Set the visibility of separators for Orbit components within the view hierarchy.
    ///
    /// - Parameters:
    ///   - isVisible: A value that will be used to decide whether Orbit components
    ///   such as ``ListChoice`` or ``TileGroup`` show separators between items.
    func showSeparator(_ isVisible: Bool = true) -> some View {
        environment(\.showSeparator, isVisible)
    }
}

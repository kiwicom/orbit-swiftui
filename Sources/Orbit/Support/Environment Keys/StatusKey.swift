import SwiftUI

struct StatusKey: EnvironmentKey {
    static let defaultValue: Status? = nil
}

public extension EnvironmentValues {

    /// An Orbit ``Status`` stored in a view’s environment.
    var status: Status? {
        get { self[StatusKey.self] }
        set { self[StatusKey.self] = newValue }
    }
}

public extension View {

    /// Set the Orbit ``Status`` for this view.
    ///
    /// - Parameters:
    ///   - status: A status that will be used by components in the view hierarchy.
    func status(_ status: Status?) -> some View {
        environment(\.status, status)
    }
}

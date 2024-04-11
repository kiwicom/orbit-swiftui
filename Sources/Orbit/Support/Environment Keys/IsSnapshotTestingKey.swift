import SwiftUI

enum IsSnapshotTestingKey: EnvironmentKey {
    static let defaultValue = false
}

public extension EnvironmentValues {

    /// Indicates whether the view is being rendered during snapshot testing.
    ///
    /// Used to modify the view to prevent snapshots from failing due to
    /// system animations or timing-related glitches.
    var isSnapshotTesting: Bool {
        get { self[IsSnapshotTestingKey.self] }
        set { self[IsSnapshotTestingKey.self] = newValue }
    }
}

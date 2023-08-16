import SwiftUI

struct IsInsideTileGroupKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {

    var isInsideTileGroup: Bool {
        get { self[IsInsideTileGroupKey.self] }
        set { self[IsInsideTileGroupKey.self] = newValue }
    }
}

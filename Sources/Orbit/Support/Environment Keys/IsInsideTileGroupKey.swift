import SwiftUI

struct IsInsideTileGroupKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {

    var isInsideTileGroup: Bool {
        get { self[IsInsideTileGroupKey.self] }
        set { self[IsInsideTileGroupKey.self] = newValue }
    }
}

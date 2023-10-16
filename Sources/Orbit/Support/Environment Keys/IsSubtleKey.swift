import SwiftUI

struct IsSubtleKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    
    var isSubtle: Bool {
        get { self[IsSubtleKey.self] }
        set { self[IsSubtleKey.self] = newValue }
    }
}

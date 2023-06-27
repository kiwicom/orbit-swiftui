import SwiftUI

struct SuppressButtonStyleKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var suppressButtonStyle: Bool {
        get { self[SuppressButtonStyleKey.self] }
        set { self[SuppressButtonStyleKey.self] = newValue }
    }
}

extension View {

    func suppressButtonStyle(_ suppress: Bool = true) -> some View {
        environment(\.suppressButtonStyle, suppress)
    }
}

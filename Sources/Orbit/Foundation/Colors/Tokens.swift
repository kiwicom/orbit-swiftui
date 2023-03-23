import SwiftUI

public extension Color {

    /// Orbit screen background color (darker in both `light` and `dark` modes).
    static let screen = Color("Screen", bundle: .orbit)

    /// Orbit screen modal overlay color.
    static let overlay = Color.inkDark.opacity(0.45)
}

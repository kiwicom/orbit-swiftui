import SwiftUI

public extension ShapeStyle where Self == Color {

    /// Orbit screen background color (darker in both `light` and `dark` modes).
    static var screen: Color { .init("Screen", bundle: .orbit) }

    /// Orbit screen modal overlay color.
    static var overlay: Color { .inkDark.opacity(0.45) }
}

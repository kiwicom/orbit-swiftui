import SwiftUI

public extension Icon {

    /// Returns a modified Orbit icon with applied vertical offset relative to its baseline.
    ///
    /// - Parameters:
    ///   - baselineOffset: The amount to shift the icon vertically (up or down) relative to its baseline.
    func baselineOffset(_ baselineOffset: CGFloat) -> Self {
        self.baselineOffset(baselineOffset as CGFloat?)
    }

    /// Returns a modified Orbit icon with applied vertical offset relative to its baseline.
    ///
    /// - Parameters:
    ///   - baselineOffset: The amount to shift the icon vertically (up or down) relative to its baseline. When the value is `nil`, the environment value will be used instead.
    func baselineOffset(_ baselineOffset: CGFloat?) -> Self {
        set(\.baselineOffset, to: baselineOffset)
    }

    /// Returns a modified Orbit icon with provided font weight.
    ///
    /// - Parameters:
    ///   - weight: One of the available font weights. When the value is `nil`, the environment value will be used instead.
    func fontWeight(_ weight: Font.Weight?) -> Self {
        set(\.fontWeight, to: weight)
    }

    /// Returns a modified Orbit icon with provided color.
    ///
    /// - Parameters:
    ///   - color: The color to use when displaying this icon.
    ///   When the value is `nil`,  the environment values `iconColor`, `textColor` or the default `inkDark` color will be used in this order.
    func iconColor(_ color: Color?) -> Self {
        set(\.color, to: color)
    }
}

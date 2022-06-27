import SwiftUI

struct OrbitFont: ViewModifier {
    // Asks the system to provide the current size category from the
    // environment, which determines what level Dynamic Type is set to.
    // The trick is that we don’t actually use it – we don’t care what the
    // Dynamic Type setting is, but by asking the system to update us when
    // it changes our UIFontMetrics code will be run at the same time,
    // causing our font to scale correctly.
    @Environment(\.sizeCategory) var sizeCategory
    let size: CGFloat
    var weight: Font.Weight = .regular
    var style: Font.TextStyle = .body

    func body(content: Content) -> some View {
        let scaledSize = sizeCategory.ratio * size // UIFontMetrics.default.scaledValue(for: size)
        return content.font(.orbit(size: size, scaledSize: scaledSize, weight: weight, style: style))
    }
}

public extension View {

    /// Sets the Orbit font as a default font for text in this view.
    ///
    /// Handles dynamic type scaling for both system and custom fonts.
    func orbitFont(size: CGFloat, weight: Font.Weight = .regular, style: Font.TextStyle = .body) -> some View {
        return self.modifier(OrbitFont(size: size, weight: weight, style: style))
    }
}

import SwiftUI

struct OrbitFont: ViewModifier {

    @Environment(\.sizeCategory) var sizeCategory

    let size: CGFloat
    var weight: Font.Weight = .regular
    var style: Font.TextStyle = .body

    func body(content: Content) -> some View {
        let scaledSize = sizeCategory.ratio * size
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

public extension SwiftUI.Text {

    /// Sets the Orbit font as a default font for text in this view.
    ///
    /// Handles dynamic type scaling for both system and custom fonts.
    func orbitFont(
        size: CGFloat,
        weight: Font.Weight = .regular,
        style: Font.TextStyle = .body,
        sizeCategory: ContentSizeCategory
    ) -> SwiftUI.Text {
        let scaledSize = sizeCategory.ratio * size

        return self.font(.orbit(size: size, scaledSize: scaledSize, weight: weight, style: style))
    }
}

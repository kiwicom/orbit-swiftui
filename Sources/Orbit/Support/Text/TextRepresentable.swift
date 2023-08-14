import SwiftUI

/// A type that can be represented as `SwiftUI.Text`
///
/// Use the `+` operator to concatenate two `TextRepresentable` elements.
public protocol TextRepresentable {

    func swiftUIText(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text?
}

/// Environment values required for proper formatting of concatenated Orbit text components.
public struct TextRepresentableEnvironment {

    public let iconColor: Color?
    public let iconSize: CGFloat?
    public let textAccentColor: Color?
    public let textColor: Color?
    public let textFontWeight: Font.Weight?
    public let textSize: CGFloat?
    public let sizeCategory: ContentSizeCategory

    public init(
        iconColor: Color?,
        iconSize: CGFloat?,
        textAccentColor: Color?,
        textColor: Color?,
        textFontWeight: Font.Weight?,
        textSize: CGFloat?,
        sizeCategory: ContentSizeCategory
    ) {
        self.iconColor = iconColor
        self.iconSize = iconSize
        self.textAccentColor = textAccentColor
        self.textColor = textColor
        self.textFontWeight = textFontWeight
        self.textSize = textSize
        self.sizeCategory = sizeCategory
    }
}

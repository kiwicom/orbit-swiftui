import SwiftUI

/// A type that can be represented as `SwiftUI.Text`
///
/// Use the `+` operator to concatenate two `TextRepresentable` elements.
public protocol TextRepresentable {

    func swiftUIText(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text?
}

/// Environment values required for proper formatting of concatenated Orbit text components.
public struct TextRepresentableEnvironment {
    let iconColor: Color?
    let iconSize: CGFloat?
    let textAccentColor: Color?
    let textColor: Color?
    let textFontWeight: Font.Weight?
    let textSize: CGFloat?
    let sizeCategory: ContentSizeCategory
}

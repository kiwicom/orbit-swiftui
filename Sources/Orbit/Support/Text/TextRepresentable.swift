import SwiftUI

/// A type that can be represented as `SwiftUI.Text`
///
/// Use the `+` operator to concatenate two `TextRepresentable` elements.
public protocol TextRepresentable {

    func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text?
}

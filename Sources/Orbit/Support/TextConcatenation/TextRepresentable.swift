import SwiftUI

// A type that can be represented as `SwiftUI.Text`
public protocol TextRepresentable {

    func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text?
}

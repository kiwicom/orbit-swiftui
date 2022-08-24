import SwiftUI

public protocol TextRepresentable {
    func swiftUITextContent(configuration: ContentSizeCategory) -> SwiftUI.Text?
}

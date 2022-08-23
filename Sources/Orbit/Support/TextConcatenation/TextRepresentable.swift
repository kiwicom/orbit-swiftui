import SwiftUI

public protocol SwiftUITextRepresentable {
    func swiftUITextContent(configuration: ContentSizeCategory) -> SwiftUI.Text?
}

import SwiftUI

public protocol SwiftUITextRepresentable {
    func asText(configuration: ContentSizeCategory) -> SwiftUI.Text?
}

extension SwiftUITextRepresentable {
    var wrapped: DynamicTextWrapper {
        .init(content: asText)
    }
}

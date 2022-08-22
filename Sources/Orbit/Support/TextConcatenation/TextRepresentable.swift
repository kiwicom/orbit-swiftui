import SwiftUI

public protocol SwiftUITextRepresentable {
    var asText: SwiftUI.Text? { get }
}

extension SwiftUI.Text: SwiftUITextRepresentable {
    public var asText: SwiftUI.Text? { self }
}

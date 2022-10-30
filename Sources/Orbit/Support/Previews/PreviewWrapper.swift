import SwiftUI

public struct OrbitPreviewWrapper<Content: View>: View {

    @ViewBuilder let content: Content

    public var body: some View {
        content
    }

    public init(@ViewBuilder content: () -> Content) {
        Font.registerOrbitFonts()
        self.content = content()
    }
}

typealias PreviewWrapper = OrbitPreviewWrapper

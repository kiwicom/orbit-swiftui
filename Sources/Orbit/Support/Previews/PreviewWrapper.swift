import SwiftUI

/// Registers Orbit fonts for preview content.
public struct OrbitPreviewWrapper<Content: View>: View {

    @ViewBuilder let content: Content

    public var body: some View {
        content
    }

    public init(@ViewBuilder content: () -> Content) {
        Font.registerOrbitFonts()
        Font.registerOrbitIconFont()
        self.content = content()
    }
}

typealias PreviewWrapper = OrbitPreviewWrapper

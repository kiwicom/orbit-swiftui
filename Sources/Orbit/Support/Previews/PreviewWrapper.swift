import SwiftUI

/// Wrapper for preview content with Orbit fonts applied.
public struct PreviewWrapper<Content: View>: View {

    @ViewBuilder let content: Content

    public var body: some View {
        content
    }

    public init(@ViewBuilder content: () -> Content) {
        Font.registerOrbitFonts()
        self.content = content()
    }
}


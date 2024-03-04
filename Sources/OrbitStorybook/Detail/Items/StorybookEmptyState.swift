import SwiftUI
import Orbit

struct StorybookEmptyState {

    static let title = "No results"
    static let description = "Try a quick search to explore hundreds of affordable options."
    static let primaryButton = "Primary action"
    static let secondaryButton = "Secondary action"

    static var basic: some View {
        VStack(spacing: .xxLarge) {
            standalone
            Separator()
            subtle
            Separator()
            noAction
        }
        .previewDisplayName()
    }

    static var standalone: some View {
        EmptyState(title, description: description, illustration: .noResults) {
            Button(primaryButton) {}
            Button(secondaryButton) {}
        }
        .previewDisplayName()
    }

    static var subtle: some View {
        EmptyState(title, description: description, illustration: .error404) {
            Button(primaryButton) {}
        }
        .status(.critical)
        .previewDisplayName()
    }

    static var noAction: some View {
        EmptyState(title, description: description, illustration: .offline)
            .previewDisplayName()
    }
}

struct StorybookEmptyStatePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookEmptyState.basic
        }
    }
}

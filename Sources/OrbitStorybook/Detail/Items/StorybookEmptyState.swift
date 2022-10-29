import SwiftUI
import Orbit

struct StorybookEmptyState {

    static let title = "Sorry, we couldn't find that connection."
    static let description = "Try changing up your search a bit. We'll try harder next time."
    static let button = "Adjust search"

    static var basic: some View {
        VStack(spacing: .xxLarge) {
            standalone
            Separator()
            subtle
            Separator()
            noAction
        }
    }

    static var standalone: some View {
        EmptyState(title, description: description, illustration: .noResults, action: .button(button))
    }

    static var subtle: some View {
        EmptyState(title, description: description, illustration: .error404, action: .button(button, style: .primarySubtle))
    }

    static var noAction: some View {
        EmptyState(title, description: description, illustration: .offline)
    }
}

struct StorybookEmptyStatePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookEmptyState.basic
        }
    }
}

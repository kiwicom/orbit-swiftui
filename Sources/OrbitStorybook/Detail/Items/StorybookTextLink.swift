import SwiftUI
import Orbit

struct StorybookTextLink {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .large) {
            Text(link("Primary link"))
            Text(link("Secondary link"))
                .textLinkColor(.secondary)
            Text(link("Info link"))
                .textLinkColor(.status(.info))
            Text(link("Success link"))
                .textLinkColor(.status(.success))
            Text(link("Warning link"))
                .textLinkColor(.status(.warning))
            Text(link("Critical link"))
                .textLinkColor(.status(.critical))
        }
        .previewDisplayName()
    }

    static func link(_ content: String) -> String {
        "<a href=\"...\">\(content)</a>"
    }

    static var live: some View {
        StateWrapper((0, "")) { state in
            VStack(spacing: .xLarge) {
                Text("Text containing <a href=\"...\">Some TextLink</a> and <a href=\"...\">Another TextLink</a>")
                    .textLinkAction {
                        state.wrappedValue.0 += 1
                        state.wrappedValue.1 = $1
                    }

                ButtonLink("ButtonLink") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "ButtonLink"
                }

                Button("Button") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "Button"
                }

                Text("Tapped \(state.wrappedValue.0)x")
                Text("Tapped \(state.wrappedValue.1)")
            }
        }
        .previewDisplayName()
    }
}

struct StorybookTextLinkPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTextLink.basic
            StorybookTextLink.live
        }
    }
}

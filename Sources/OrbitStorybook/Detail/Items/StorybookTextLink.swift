import SwiftUI
import Orbit

struct StorybookTextLink {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .large) {
            Text(link("Primary link"), linkColor: .primary)
            Text(link("Secondary link"), linkColor: .secondary)
            Text(link("Info link"), linkColor: .status(.info))
            Text(link("Success link"), linkColor: .status(.success))
            Text(link("Warning link"), linkColor: .status(.warning))
            Text(link("Critical link"), linkColor: .status(.critical))
        }
    }

    static func link(_ content: String) -> String {
        "<a href=\"...\">\(content)</a>"
    }

    static var live: some View {
        StateWrapper(initialState: (0, "")) { state in
            VStack(spacing: .xLarge) {
                Text("Text containing <a href=\"...\">Some TextLink</a> and <a href=\"...\">Another TextLink</a>") { link, text in
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = text
                }

                ButtonLink("ButtonLink") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "ButtonLink"
                }

                Button("Button") {
                    state.wrappedValue.0 += 1
                    state.wrappedValue.1 = "Button"
                }

                Text("Tapped \(state.wrappedValue.0)x", color: .inkNormal)
                Text("Tapped \(state.wrappedValue.1)", color: .inkNormal)
            }
        }
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

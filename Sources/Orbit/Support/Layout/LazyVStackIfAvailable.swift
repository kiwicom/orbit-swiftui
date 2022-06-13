import SwiftUI

struct LazyVStackIfAvailable<Content: View>: View {

    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat? = nil
    @ViewBuilder let content: Content

    var body: some View {
        if #available(iOS 14.0, *) {
            LazyVStack(alignment: alignment, spacing: spacing) {
                content
            }
        } else {
            VStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}

// MARK: - Previews
struct LazyVStackIfAvailablePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        LazyVStackIfAvailable {
            Text("Text 1")
            Text("Text 2")
        }
    }
}

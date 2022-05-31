import SwiftUI

struct LazyVStackIfAvailable<Content: View>: View {

    let content: () -> Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat?

    var body: some View {
        if #available(iOS 14.0, *) {
            LazyVStack(alignment: alignment, spacing: spacing) {
                content()
            }
        } else {
            VStack(alignment: alignment, spacing: spacing) {
                content()
            }
        }
    }
}

// MARK: - Inits
extension LazyVStackIfAvailable {

    init(
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
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

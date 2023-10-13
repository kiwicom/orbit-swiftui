import SwiftUI

struct LazyVStack<Content: View>: View {

    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat? = nil
    @ViewBuilder let content: Content

    var body: some View {
        if #available(iOS 14.0, *) {
            SwiftUI.LazyVStack(alignment: alignment, spacing: spacing) {
                content
            }
        } else {
            VStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}

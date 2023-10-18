import SwiftUI

extension PreviewProvider {

    @ViewBuilder static var headerPlaceholder: some View {
        Text("Custom\nheader content")
            .padding(.vertical, .medium)
            .frame(maxWidth: .infinity)
            .background(Color.blueLightActive)
    }

    @ViewBuilder static var illustrationPlaceholder: some View {
        Text("Illustration\ncontent")
            .padding(.vertical, .medium)
            .frame(minWidth: 100, maxWidth: 300, maxHeight: 200)
            .background(Color.pink)
    }

    @ViewBuilder static var contentPlaceholder: some View {
        Color.productLightActive.opacity(0.3)
            .frame(height: 80)
            .overlay(
                Text("Custom content")
                    .textColor(.inkNormal)
            )
    }

    @ViewBuilder static var intrinsicContentPlaceholder: some View {
        Text("Content")
            .textColor(.inkNormal)
            .padding(.medium)
            .background(Color.productLightActive.opacity(0.3))
    }
}

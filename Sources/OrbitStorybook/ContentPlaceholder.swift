import SwiftUI
import Orbit

@ViewBuilder var headerPlaceholder: some View {
    Text("Custom\nheader content")
        .padding(.vertical, .medium)
        .frame(maxWidth: .infinity)
        .background(Color.blueLightActive)
}

@ViewBuilder var contentPlaceholder: some View {
    Color.productLightActive.opacity(0.3)
        .frame(height: 80)
        .overlay(
            Text("Custom content")
                .textColor(.inkNormal)
        )
}

@ViewBuilder var intrinsicContentPlaceholder: some View {
    Text("Content")
        .textColor(.inkNormal)
        .padding(.medium)
        .background(Color.productLightActive.opacity(0.3))
}

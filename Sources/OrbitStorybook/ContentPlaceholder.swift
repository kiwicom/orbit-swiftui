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
                .foregroundColor(.inkNormal)
        )
}

@ViewBuilder var intrinsicContentPlaceholder: some View {
    Text("Content")
        .foregroundColor(.inkNormal)
        .padding(.medium)
        .background(Color.productLightActive.opacity(0.3))
}

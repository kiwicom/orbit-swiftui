import SwiftUI
import Orbit

@ViewBuilder var contentPlaceholder: some View {
    Color.productLightActive.opacity(0.3)
        .frame(height: 80)
        .overlay(Text("Custom content", color: .inkNormal))
}

@ViewBuilder var intrinsicContentPlaceholder: some View {
    Text("Intrinsic content", color: .inkNormal)
        .padding(.medium)
        .background(Color.productLightActive.opacity(0.3))
}

import SwiftUI

extension PreviewProvider {
    
    @ViewBuilder static var contentPlaceholder: some View {
        Color.productLightActive.opacity(0.3)
            .frame(height: 80)
            .overlay(Text("Custom content", color: .inkLight))
    }

    @ViewBuilder static var intrinsicContentPlaceholder: some View {
        Text("Intrinsic content", color: .inkLight)
            .padding(.medium)
            .background(Color.productLightActive.opacity(0.3))
    }
}

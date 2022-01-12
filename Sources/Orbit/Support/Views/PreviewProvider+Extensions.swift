import SwiftUI

extension PreviewProvider {
    
    @ViewBuilder static var customContentPlaceholder: some View {
        Color.productLightActive.opacity(0.3)
            .frame(height: 80)
            .overlay(Text("Custom content", color: .inkLight))
    }
}

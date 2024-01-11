import SwiftUI
import Orbit

@ViewBuilder var headerPlaceholder: some View {
    Text("Header\ncontent")
        .textColor(.blueDark)
        .frame(maxWidth: .infinity)
        .padding(.medium)
        .background(Color.blueLightActive)
        .border(.blueNormal, width: .hairline)
        .opacity(0.3)
}

@ViewBuilder var illustrationPlaceholder: some View {
    Text("Illustration\ncontent")
        .padding(.vertical, .medium)
        .frame(minWidth: 100, maxWidth: 300, maxHeight: 200)
        .background(Color.orangeLightActive)
        .border(.orangeNormal, width: .hairline)
        .opacity(0.3)
}

@ViewBuilder var contentPlaceholder: some View {
    Text("Custom\nContent")
        .textColor(.productDark)
        .padding(.medium)
        .frame(maxWidth: .infinity)
        .background(Color.productLightActive)
        .border(.productNormal, width: .hairline)
        .opacity(0.3)
}

@ViewBuilder var intrinsicContentPlaceholder: some View {
    Text("Content")
        .textColor(.productDark)
        .padding(.medium)
        .background(Color.productLightActive)
        .border(.productNormal, width: .hairline)
        .opacity(0.3)
}

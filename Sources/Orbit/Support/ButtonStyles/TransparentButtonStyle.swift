import SwiftUI

// Used to highlight a button, possibly invisible one (adding contentShape to fix interaction)
struct TransparentButtonStyle: ButtonStyle {

    let isActive: Bool
    let borderWidth: CGFloat
    let pressedOpacity: Double

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            if isActive {
                configuration.label
                    .padding(configuration.isPressed ? 1 : 0)
                    .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            } else {
                configuration.label
                    .overlay(
                        Color.whiteDarker
                            .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
                            .padding(borderWidth)
                            .opacity(configuration.isPressed ? pressedOpacity : 0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            }
        }
    }
}

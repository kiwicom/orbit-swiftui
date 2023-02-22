import SwiftUI

/// An icon-based stepper button for suitable for actions inside components like `Stepper`
public struct StepperButton: View {
    
    let isIncrement: Bool
    let isEnabled: Bool
    let style: Stepper.Style
    let action: () -> Void
    
    public var body: some View {
        SwiftUI.Button(action: action) {
            icon
        }
        .buttonStyle(OrbitStyle(isEnabled: isEnabled, style: style))
        .disabled(!isEnabled)
    }
    
    var icon: Icon {
        let color = isEnabled ? style.foregroundActiveColor : style.foregroundColor

        return isIncrement ? .init(.plus, color: color) : .init(.minus, color: color)
    }
}

// MARK: - Button Style

extension StepperButton {
    
    struct OrbitStyle: ButtonStyle {
        let isEnabled: Bool
        let style: Stepper.Style
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    Circle()
                        .strokeBorder(
                            style.borderSelectedColor,
                            lineWidth: configuration.isPressed ? 2 : 0
                        )
                        .background(
                            Circle()
                                .fill(isEnabled ? style.backgroundActiveColor : style.backgroundColor)
                        )
                )
        }
    }
}

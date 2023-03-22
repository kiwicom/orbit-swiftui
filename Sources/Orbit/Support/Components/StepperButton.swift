import SwiftUI

/// An icon-based stepper button for suitable for actions inside components like `Stepper`.
public struct StepperButton: View {

    @Environment(\.sizeCategory) var sizeCategory

    let isIncrement: Bool
    let isEnabled: Bool
    let style: Stepper.Style
    let action: () -> Void
    
    public var body: some View {
        SwiftUI.Button(action: action) {
            Icon(icon, color: color)
        }
        .frame(width: size, height: size)
        .buttonStyle(OrbitStyle(isEnabled: isEnabled, style: style))
        .disabled(!isEnabled)
    }
    
    var icon: Icon.Symbol {
        isIncrement ? .plus : .minus
    }

    var color: Color {
        isEnabled ? style.foregroundActiveColor : style.foregroundColor
    }

    var size: CGFloat {
        .xxLarge * sizeCategory.controlRatio
    }

    public init(
        isIncrement: Bool,
        isEnabled: Bool = true,
        style: Stepper.Style = .primary,
        action: @escaping () -> Void
    ) {
        self.isIncrement = isIncrement
        self.isEnabled = isEnabled
        self.style = style
        self.action = action
    }
}

// MARK: - Button Style

extension StepperButton {
    
    struct OrbitStyle: ButtonStyle {
        let isEnabled: Bool
        let style: Stepper.Style
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.xxxSmall)
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

// MARK: - Previews
struct StepperButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StepperButton(isIncrement: false) {}
    }
}

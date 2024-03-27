import SwiftUI

/// Orbit support component that displays icon-based stepper button for suitable for actions inside components like ``Stepper``.
public struct StepperButton: View {

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.sizeCategory) private var sizeCategory

    private let icon: Icon.Symbol
    private let style: Stepper.Style
    private let action: () -> Void
    
    public var body: some View {
        SwiftUI.Button {
            action()
        } label: {
            Icon(icon)
                .textColor(color)
        }
        .frame(width: size, height: size)
        .buttonStyle(OrbitStyle(style: style))
    }

    private var color: Color {
        isEnabled ? style.textActiveColor : style.textColor
    }

    private var size: CGFloat {
        .xxLarge * sizeCategory.controlRatio
    }
    
    /// Creates Orbit ``StepperButton`` component used in a ``Stepper``.
    public init(
        _ icon: Icon.Symbol,
        style: Stepper.Style = .primary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.action = action
    }
}

// MARK: - Button Style
extension StepperButton {
    
    struct OrbitStyle: ButtonStyle {

        @Environment(\.isEnabled) var isEnabled
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
            primary
            primaryDisabled
            secondary
            secondaryDisabled
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var primary: some View {
        StepperButton(.plus) {}
            .previewDisplayName()
    }

    static var primaryDisabled: some View {
        StepperButton(.plus) {}
            .environment(\.isEnabled, false)
            .previewDisplayName()
    }

    static var secondary: some View {
        StepperButton(.plus, style: .secondary) {}
            .previewDisplayName()
    }

    static var secondaryDisabled: some View {
        StepperButton(.plus, style: .secondary) {}
            .environment(\.isEnabled, false)
            .previewDisplayName()
    }
}

import SwiftUI

/// Enables incremental changes of a counter without a direct input.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/stepper/)
public struct Stepper: View {
    
    @Binding var value: Int
    
    let minValue: Int
    let maxValue: Int
    let style: Style
    
    @Environment(\.isEnabled) var isEnabled
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            decrementButton
            
            valueText
                .frame(minWidth: 40)
            
            incrementButton
        }
    }
    
    @ViewBuilder var valueText: some View {
        Text("\(value)")
            .accessibility(.stepperValue)
            .accessibility(value: .init(value.description))
    }
    
    @ViewBuilder var decrementButton: some View {
        StepperButton(
            isIncrement: false,
            isEnabled: isEnabled ? value > minValue : false,
            style: style,
            action: {
                value -= 1
            }
        )
        .accessibility(.stepperDecrement)
    }
    
    @ViewBuilder var incrementButton: some View {
        StepperButton(
            isIncrement: true,
            isEnabled: isEnabled ? value < maxValue : false,
            style: style,
            action: {
                value += 1
            }
        )
        .accessibility(.stepperIncrement)
    }
    
    /// Creates Orbit Stepper component.
    public init(
        value: Binding<Int>,
        minValue: Int,
        maxValue: Int,
        style: Style
    ) {
        self._value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.style = style
    }
}

// MARK: - Styles
extension Stepper {
    
    public enum Style {
        case primary
        case secondary
        
        public var foregroundColor: Color {
            switch self {
            case .primary:                  return .white.opacity(0.5)
            case .secondary:                return .inkDark.opacity(0.5)
            }
        }
        
        public var foregroundActiveColor: Color {
            switch self {
            case .primary:                  return .white
            case .secondary:                return .inkDark
            }
        }
        
        public var backgroundColor: Color {
            switch self {
            case .primary:                  return .blueNormal.opacity(0.5)
            case .secondary:                return .cloudNormal.opacity(0.5)
            }
        }
        
        public var backgroundActiveColor: Color {
            switch self {
            case .primary:                  return .blueNormal
            case .secondary:                return .cloudNormal
            }
        }
        
        public var borderSelectedColor: Color {
            switch self {
            case .primary:                  return .blueLightActive
            case .secondary:                return .cloudNormalActive
            }
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    
    static let stepperIncrement         = Self(rawValue: "orbit.stepper.increment")
    static let stepperDecrement         = Self(rawValue: "orbit.stepper.decrement")
    static let stepperValue             = Self(rawValue: "orbit.stepper.value")
}

// MARK: - Previews
struct StepperPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            states
            statesLargeFont
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
    
    static var zeroToTen: some View {
        StateWrapper(3) { binding in
            Stepper(
                value: binding,
                minValue: -4,
                maxValue: 10,
                style: .primary
            )
        }
    }
    
    static var minusFiveToTwenty: some View {
        StateWrapper(-3) { binding in
            Stepper(
                value: binding,
                minValue: -5,
                maxValue: 20,
                style: .primary
            )
        }
    }
    
    static var twoToFifteen: some View {
        StateWrapper(2) { binding in
            Stepper(
                value: binding,
                minValue: 2,
                maxValue: 15,
                style: .primary
            )
        }
    }
    
    static var zeroToThree: some View {
        StateWrapper(2) { binding in
            Stepper(
                value: binding,
                minValue: 0,
                maxValue: 3,
                style: .primary
            )
        }
    }
    
    static var disabledZeroToThree: some View {
        StateWrapper(2) { binding in
            Stepper(
                value: binding,
                minValue: 0,
                maxValue: 3,
                style: .primary
            )
            .disabled(true)
        }
    }
    
    static var secondaryThreeToTen: some View {
        StateWrapper(5) { binding in
            Stepper(
                value: binding,
                minValue: 3,
                maxValue: 10,
                style: .secondary
            )
        }
    }
    
    static var standalone: some View {
        zeroToTen
            .previewDisplayName()
    }
    
    static var states: some View {
        VStack(spacing: .large) {
            minusFiveToTwenty
            twoToFifteen
            zeroToThree
            disabledZeroToThree
            secondaryThreeToTen
        }
        .previewDisplayName()
    }
    
    static var statesLargeFont: some View {
        VStack(spacing: .large) {
            minusFiveToTwenty
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            disabledZeroToThree
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            secondaryThreeToTen
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
        .previewDisplayName()
    }
    
    static var snapshot: some View {
        states
            .padding(.medium)
    }
    
    static var snapshotLargeFont: some View {
        statesLargeFont
            .padding(.medium)
    }
}

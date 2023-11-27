import SwiftUI

/// Orbit input component that displays a value with and inputs to make incremental changes.
/// A counterpart of the native `SwiftUI.Stepper`.
///
/// A ``Stepper`` consists of a value and increment and decrement buttons. 
///
/// ```swift
/// Stepper(
///     value: $value,
///     minValue: -5,
///     maxValue: 20
/// )
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/interaction/stepper/)
public struct Stepper: View {
    
    @Environment(\.isEnabled) private var isEnabled
    
    @Binding private var value: Int
    private let maxValue: Int
    private let minValue: Int
    private let style: Style
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            decrementButton
            valueText
            incrementButton
        }
    }
    
    @ViewBuilder private var valueText: some View {
        Text("\(value)")
            .frame(minWidth: .xMedium)
            .accessibility(.stepperValue)
            .accessibility(value: .init(value.description))
    }
    
    @ViewBuilder private var decrementButton: some View {
        StepperButton(.minus, style: style) {
            value -= 1
        }
        .environment(\.isEnabled, isEnabled && value > minValue)
        .accessibility(.stepperDecrement)
    }
    
    @ViewBuilder private var incrementButton: some View {
        StepperButton(.plus, style: style) {
            value += 1
        }
        .environment(\.isEnabled, isEnabled && value < maxValue)
        .accessibility(.stepperIncrement)
    }
}

// MARK: - Inits
public extension Stepper {
    
    /// Creates Orbit ``Stepper`` component.
    init(
        value: Binding<Int>,
        minValue: Int,
        maxValue: Int,
        style: Style = .primary
    ) {
        self._value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.style = style
    }
}

// MARK: - Styles
extension Stepper {
    
    /// Orbit ``Stepper`` style.
    public enum Style {
        case primary
        case secondary
        
        public var textColor: Color {
            switch self {
                case .primary:                  return .white.opacity(0.5)
                case .secondary:                return .inkDark.opacity(0.5)
            }
        }
        
        public var textActiveColor: Color {
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
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var states: some View {
        VStack(spacing: .large) {
            minusFiveToTwenty
            twoToFifteen
            disabledZeroToThree
            secondaryThreeToTen
            secondaryDisabled
        }
        .previewDisplayName()
    }
    
    static var standalone: some View {
        StateWrapper(10) { binding in
            Stepper(
                value: binding,
                minValue: -30,
                maxValue: 30,
                style: .secondary
            )
        }
        .previewDisplayName()
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
                maxValue: 15
            )
        }
    }
    
    static var disabledZeroToThree: some View {
        StateWrapper(2) { binding in
            Stepper(
                value: binding,
                minValue: 0,
                maxValue: 3
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

    static var secondaryDisabled: some View {
        StateWrapper(5) { binding in
            Stepper(
                value: binding,
                minValue: 3,
                maxValue: 10,
                style: .secondary
            )
            .environment(\.isEnabled, false)
        }
    }
    
    static var snapshot: some View {
        states
            .padding(.medium)
    }
}

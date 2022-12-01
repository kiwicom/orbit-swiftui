import SwiftUI
import Orbit

struct StorybookStepper {

    static var basic: some View {
        VStack(spacing: .large) {
            minusFiveToTwenty
            twoToFifteen
            zeroToThree
            disabledZeroToThree
            secondaryThreeToTen
        }
        .previewDisplayName()
    }
    
    @ViewBuilder static var zeroToTen: some View {
        StateWrapper(3) { binding in
            Stepper(
                value: binding,
                minValue: -4,
                maxValue: 10,
                style: .primary
            )
        }
    }

    @ViewBuilder static var minusFiveToTwenty: some View {
        StateWrapper(-3) { binding in
            Stepper(
                value: binding,
                minValue: -5,
                maxValue: 20,
                style: .primary
            )
        }
    }

    @ViewBuilder static var twoToFifteen: some View {
        StateWrapper(2) { binding in
            Stepper(
                value: binding,
                minValue: 2,
                maxValue: 15,
                style: .primary
            )
        }
    }
    
    @ViewBuilder static var zeroToThree: some View {
        StateWrapper(2) { binding in
            Stepper(
                value: binding,
                minValue: 0,
                maxValue: 3,
                style: .primary
            )
        }
    }

    @ViewBuilder static var disabledZeroToThree: some View {
        StateWrapper(2) { binding in
            Stepper(
                value: binding,
                minValue: 0,
                maxValue: 3,
                style: .primary
            )
            .disabled(false)
        }
    }

    @ViewBuilder static var secondaryThreeToTen: some View {
        StateWrapper(5) { binding in
            Stepper(
                value: binding,
                minValue: 3,
                maxValue: 10,
                style: .secondary
            )
        }
    }
}

struct StorybookStepperPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookStepper.basic
        }
    }
}

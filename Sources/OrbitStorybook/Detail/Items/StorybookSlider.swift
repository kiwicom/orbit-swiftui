import SwiftUI
import Orbit

struct StorybookSlider {

    static var basic: some View {
        VStack(spacing: .large) {
            slider(value: 30, bounds: 0...100)
            slider(range: 30...70, bounds: 0...100)
            slider(value: 50, bounds: 0...100, step: 10)
            slider(range: 20...50, bounds: 0...100, step: 10)
        }
        .previewDisplayName()
    }

    @ViewBuilder
    static func slider(value: Double, bounds: ClosedRange<Double>, step: Double? = nil) -> some View {
        StateWrapper(value) { value in
            Slider(value: value, bounds: bounds, step: step)
        }
    }

    @ViewBuilder
    static func slider(range: ClosedRange<Double>, bounds: ClosedRange<Double>, step: Double? = nil) -> some View {
        StateWrapper(range) { selectedRange in
            Slider(selectedRange: selectedRange, bounds: bounds, step: step)
        }
    }
}

extension Orbit.Slider where Value == Double {
    init(value: Binding<Value>, bounds: ClosedRange<Value>, step: Value.Stride? = nil) {
        self.init(
            value: value,
            valueLabel: value.wrappedValue.formatted,
            startLabel: bounds.lowerBound.formatted,
            endLabel: bounds.upperBound.formatted,
            range: bounds,
            step: step
        )
    }

    init(selectedRange: Binding<ClosedRange<Value>>, bounds: ClosedRange<Value>, step: Value.Stride? = nil) {
        let value = selectedRange.wrappedValue
        self.init(
            valueRange: selectedRange,
            valueLabel:  "\(value.lowerBound.formatted) - \(value.upperBound.formatted)",
            startLabel: bounds.lowerBound.formatted,
            endLabel: bounds.upperBound.formatted,
            range: bounds, step: step)
    }
}

struct StorybookSliderPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookSlider.basic
        }
    }
}

extension Double {

    var formatted: String {
        abs(self.remainder(dividingBy: 1)) <= 0.001
            ? .init(format: "%.0f", self)
            : .init(format: "%.2f", self)
    }
}

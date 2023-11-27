import SwiftUI

public typealias SliderValue = BinaryFloatingPoint & Strideable & CustomStringConvertible

/// Orbit input component that displays a range of values.
/// A counterpart of the native `SwiftUI.Slider`.
///
/// A ``Slider`` consists of a label and two or three choices. 
///
/// ```swift
/// Slider(
///     value: $value,
///     valueLabel: value.description,
///     startLabel: "15",
///     endLabel: "200",
///     range: 15...200
/// )
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier.
/// 
/// ### Layout
/// 
/// Component expands horizontally.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/interaction/slider/)
public struct Slider<Value>: View where Value: SliderValue, Value.Stride: BinaryFloatingPoint {

    private enum SelectedValue {
        case single(Binding<Value>?)
        case range(Binding<ClosedRange<Value>>?)
    }

    @Environment(\.sizeCategory) private var sizeCategory

    private let value: SelectedValue
    private let valueLabel: String
    private let startLabel: String
    private let endLabel: String
    private let range: ClosedRange<Value>

    @State private var isFirstThumbDrag = false
    @State private var isSecondThumbDrag = false
    @State private var firstValue: Value {
        didSet {
            switch value {
                case .single(let currentValue):
                    currentValue?.wrappedValue = firstValue
                case .range:
                    updateSelectedRangeIfNeeded()
            }
        }
    }

    @State private var secondValue: Value? {
        didSet {
            updateSelectedRangeIfNeeded()
        }
    }

    @State private var dragStartOffset = 0.0

    private let buckets: [Range<Value>]

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(valueLabel)
                .textColor(.blueNormal)
                .padding(.bottom, .medium)
                .accessibility(.sliderValueLabel)

            SingleAxisGeometryReader(axis: .horizontal, alignment: .bottom) { width in
                track
                    .overlay(
                        controls(sliderWidth: width)
                    )
                    .padding(.vertical, thumbVerticalOverlapping)
            }

            HStack(alignment: .center, spacing: 0) {
                Text(startLabel)
                    .textColor(.inkNormal)
                Spacer(minLength: .medium)
                Text(endLabel)
                    .textColor(.inkNormal)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.top, .xxSmall)
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(valueLabel))
        .accessibility(hint: .init(accessibilityHint))
    }

    @ViewBuilder private var track: some View {
        RoundedRectangle(cornerRadius: lineHeight)
            .fill(.cloudDark)
            .frame(minHeight: lineHeight, maxHeight: lineHeight)
    }

    @ViewBuilder private func controls(sliderWidth: CGFloat) -> some View {
        let thumbDiameter = SliderThumb.circleDiameter * sizeCategory.controlRatio
        let thumbRadius = thumbDiameter / 2
        let thumbTrackWidth = sliderWidth - thumbDiameter

        let firstThumbPosition = position(by: firstValue, width: thumbTrackWidth)

        if let secondValue {
            let secondThumbPosition = position(by: secondValue, width: thumbTrackWidth)

            ZStack {
                firstThumb(atPosition: firstThumbPosition, width: thumbTrackWidth)
                    .accessibility(.sliderFirstThumb)
                secondThumb(atPosition: secondThumbPosition, width: thumbTrackWidth)
                    .accessibility(.sliderSecondThumb)
            }
            .padding(.leading, thumbRadius)
            .background(strokedPath(from: firstThumbPosition, to: secondThumbPosition))
        } else {
            firstThumb(atPosition: firstThumbPosition, width: thumbTrackWidth)
                .accessibility(.sliderFirstThumb)
                .padding(.leading, thumbRadius)
                .background(strokedPath(from: 0, to: firstThumbPosition))
        }
    }

    @ViewBuilder private func firstThumb(atPosition horizontalPosition: CGFloat, width: CGFloat) -> some View {
        thumb(
            horizontalPosition: horizontalPosition,
            width: width,
            isDragging: $isFirstThumbDrag
        ) {
            firstValue = $0
        }
        .zIndex(isFirstThumbDrag ? 1 : 0)
    }

    @ViewBuilder private func secondThumb(atPosition horizontalPosition: CGFloat, width: CGFloat) -> some View {
        thumb(
            horizontalPosition: horizontalPosition,
            width: width,
            isDragging: $isSecondThumbDrag
        ) {
            secondValue = $0
        }
        .zIndex(isSecondThumbDrag ? 1 : 0)
    }

    @ViewBuilder private func thumb(
        horizontalPosition: CGFloat,
        width: CGFloat,
        isDragging: Binding<Bool>,
        onValueChange: @escaping (Value) -> Void
    ) -> some View {
        SliderThumb()
            .position(x: horizontalPosition, y: lineCenter)
            .highPriorityGesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in

                        if isDragging.wrappedValue == false {
                            dragStartOffset = value.startLocation.x - horizontalPosition
                            isDragging.wrappedValue = true
                        }

                        let newHorizontalPosition = value.location.x - dragStartOffset

                        guard newHorizontalPosition < width else {
                            onValueChange(range.upperBound)
                            return
                        }

                        guard newHorizontalPosition > 0 else {
                            onValueChange(range.lowerBound)
                            return
                        }

                        if buckets.count > 1 {
                            let currentValue = currentValue(location: newHorizontalPosition, width: width)
                            guard let bucket = buckets.first(where: { $0.contains(currentValue) }) else { return }
                            onValueChange(currentValue < bucket.middle ? bucket.lowerBound : bucket.upperBound)
                        } else {
                            onValueChange(currentValue(location: newHorizontalPosition, width: width))
                        }
                    }
                    .onEnded { _ in
                        isDragging.wrappedValue = false
                        dragStartOffset = 0
                    }
            )
    }

    @ViewBuilder private func strokedPath(from: CGFloat, to: CGFloat) -> some View {
        Path { path in
            path.move(to: .init(x: from, y: lineCenter))
            path.addLine(to: .init(x: to, y: lineCenter))
        }
        .stroke(.blueNormal, lineWidth: lineHeight)
        .cornerRadius(lineHeight)
    }

    private var lineHeight: CGFloat {
        CGFloat.xxSmall * sizeCategory.controlRatio
    }

    private var lineCenter: CGFloat {
        lineHeight / 2
    }

    private var thumbVerticalOverlapping: CGFloat {
        (SliderThumb.circleDiameter / 2 - lineCenter) * sizeCategory.controlRatio
    }

    private var accessibilityHint: String {
        "\(startLabel) - \(endLabel)"
    }

    private func updateSelectedRangeIfNeeded() {
        if let upperBound = secondValue, case .range(let selectedRange) = value {
            selectedRange?.wrappedValue = min(firstValue, upperBound)...max(firstValue, upperBound)
        }
    }

    private func currentValue(location: CGFloat, width: CGFloat) -> Value {
        range.lowerBound + Value(location / width) * range.distance
    }

    private func position(by value: Value, width: CGFloat) -> CGFloat {
        let position = CGFloat((value - range.lowerBound) / range.distance) * width
        return min(width, max(0, position))
    }
}

// MARK: - Inits
public extension Slider {

    /// Creates Orbit ``Slider`` component.
    init(
        value: Binding<Value>,
        valueLabel: String = "",
        startLabel: String,
        endLabel: String,
        range: ClosedRange<Value>,
        step: Value.Stride? = nil
    ) {
        if let step {
            assert(step > 0, "step has to be positive")
        }

        self.value = .single(value)
        self.valueLabel = valueLabel
        self.startLabel = startLabel
        self.endLabel = endLabel

        self.range = range

        self._firstValue = State(initialValue: value.wrappedValue)
        self.buckets = range.chunked(into: step ?? Value.Stride(range.upperBound - range.lowerBound))
    }

    /// Creates Orbit ``Slider`` component with a binding to a closed range value.
    init(
        valueRange: Binding<ClosedRange<Value>>,
        valueLabel: String = "",
        startLabel: String,
        endLabel: String,
        range: ClosedRange<Value>,
        step: Value.Stride? = nil
    ) {
        if let step {
            assert(step > 0, "step has to be positive number")
        }

        self.value = .range(valueRange)
        self.valueLabel = valueLabel
        self.startLabel = startLabel
        self.endLabel = endLabel
        self.range = range

        self._firstValue = State(initialValue: valueRange.wrappedValue.lowerBound)
        self._secondValue = State(initialValue: valueRange.wrappedValue.upperBound)

        self.buckets = range.chunked(into: step ?? Value.Stride(range.upperBound))
    }
}

// MARK: - Types

extension ClosedRange where Bound: BinaryFloatingPoint {

    var distance: Bound {
        upperBound - lowerBound
    }

    func chunked(into size: Bound.Stride) -> [Range<Bound>] {
        stride(from: lowerBound, to: upperBound, by: size).map { value in
            value..<Swift.min(value.advanced(by: size), upperBound)
        }
    }
}

extension Range where Bound: BinaryFloatingPoint {

    var middle: Bound {
        lowerBound + (upperBound - lowerBound) / 2
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let sliderValueLabel = Self(rawValue: "sliderValueLabel")
    static let sliderFirstThumb = Self(rawValue: "sliderFirstThumb")
    static let sliderSecondThumb = Self(rawValue: "sliderSecondThumb")
}

// MARK: - Previews
struct SliderPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            slider
            steppedSlider
            rangeSlider
            steppedRangeSlider
            interactiveSliders
        }
        .padding(.xLarge)
        .previewLayout(.sizeThatFits)
    }

    static var slider: some View {
        StateWrapper(30.0) { value in
            Slider(
                value: value,
                valueLabel: value.wrappedValue.description,
                startLabel: 15.formatted,
                endLabel: 200.formatted,
                range: 15...200
            )
        }
        .previewDisplayName()
    }

    static var steppedSlider: some View {
        StateWrapper(30.0) { value in
            Slider(
                value: value,
                valueLabel: value.wrappedValue.description,
                startLabel: 0.formatted,
                endLabel: 100.formatted,
                range: 0...100,
                step: 10
            )
        }
        .previewDisplayName()
    }

    static var rangeSlider: some View {
        StateWrapper(30.0...70.0) { selectedRange in
            Slider(
                valueRange: selectedRange,
                valueLabel: "\(selectedRange.wrappedValue.lowerBound.formatted) - \(selectedRange.wrappedValue.upperBound.formatted)",
                startLabel: 0.formatted,
                endLabel: 100.formatted,
                range: 0...100
            )
        }
        .previewDisplayName()
    }

    static var steppedRangeSlider: some View {
        StateWrapper(30.0...70.0) { selectedRange in
            Slider(
                valueRange: selectedRange,
                valueLabel: "\(selectedRange.wrappedValue.lowerBound.formatted) - \(selectedRange.wrappedValue.upperBound.formatted)",
                startLabel: 0.formatted,
                endLabel: 100.formatted,
                range: 0...100,
                step: 10
            )
        }
        .previewDisplayName()
    }

    static var interactiveSliders: some View {
        VStack(spacing: .small) {
            StateWrapper(30.0) { value in
                VStack(alignment: .leading, spacing: .medium) {
                    Text("Slider")
                        .textSize(.xLarge)

                    Slider(
                        value: value,
                        valueLabel: value.wrappedValue.description,
                        startLabel: (-50).formatted,
                        endLabel: 50.formatted,
                        range: -50...50
                    )
                }
            }

            StateWrapper(5.0) { value in
                VStack(alignment: .leading, spacing: .medium) {
                    Text("Stepped Slider")
                        .textSize(.xLarge)

                    Slider(
                        value: value,
                        valueLabel: value.wrappedValue.description,
                        startLabel: (-5).formatted,
                        endLabel: 15.formatted,
                        range: -5...15,
                        step: 0.5
                    )
                }
            }

            StateWrapper(30.0...70.0) { selectedRange in
                VStack(alignment: .leading, spacing: .medium) {
                    Text("Range Slider")
                        .textSize(.xLarge)

                    Slider(
                        valueRange: selectedRange,
                        valueLabel: "\(selectedRange.wrappedValue.lowerBound.formatted) - \(selectedRange.wrappedValue.upperBound.formatted)",
                        startLabel: 0.formatted,
                        endLabel: 100.formatted,
                        range: 0...100
                    )
                }
            }

            StateWrapper(30.0...70.0) { selectedRange in
                VStack(alignment: .leading, spacing: .medium) {
                    Text("Stepped Range Slider")
                        .textSize(.xLarge)

                    Slider(
                        valueRange: selectedRange,
                        valueLabel: "\(selectedRange.wrappedValue.lowerBound.formatted) - \(selectedRange.wrappedValue.upperBound.formatted)",
                        startLabel: 0.formatted,
                        endLabel: 100.formatted,
                        range: 0...100,
                        step: 10
                    )
                }
            }

            StateWrapper(30.0) { value in
                VStack(alignment: .leading, spacing: .small) {
                    Text("SwiftUI.Slider")
                        .textSize(.xLarge)

                    SwiftUI.Slider(value: value, in: 0.0...100.0)

                    SwiftUI.Slider(value: value, in: 0.0...100.0, step: 20.0) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }

                    Text("Value: \(value.wrappedValue)")
                }
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(spacing: .xxLarge) {
            slider
            rangeSlider
        }
        .padding(.medium)
    }
}

import SwiftUI

/// Enables users to pick exactly one option from a group.
///
/// Can be also used to display just the radio rounded indicator.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/radio/)
public struct Radio: View {

    @Environment(\.isEnabled) var isEnabled

    let title: String
    let description: String
    let state: State
    @Binding var isChecked: Bool

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                isChecked.toggle()
            },
            label: {
                if title.isEmpty == false || description.isEmpty == false {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(title, color: labelColor, weight: .medium)
                            .accessibility(.radioTitle)
                        Text(description, size: .small, color: descriptionColor)
                            .accessibility(.radioDescription)
                    }
                }
            }
        )
        .buttonStyle(
            ButtonStyle(state: state, isChecked: isChecked)
        )
    }

    var labelColor: Text.Color {
        isEnabled ? .inkDark : .custom(.cloudDarkHover)
    }

    var descriptionColor: Text.Color {
        isEnabled ? .inkNormal : .custom(.cloudDarkHover)
    }
}

// MARK: - Inits
public extension Radio {
    
    /// Creates Orbit Radio component.
    init(
        _ title: String = "",
        description: String = "",
        state: State = .normal,
        isChecked: Binding<Bool>
    ) {
        self.init(title: title, description: description, state: state, isChecked: isChecked)
    }
}

// MARK: - Types
public extension Radio {
    
    enum State {
        case normal
        case error
    }
}

// MARK: - ButtonStyle
extension Radio {

    /// Button style wrapper for radio input.
    /// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ButtonStyle: SwiftUI.ButtonStyle {

        public static let size: CGFloat = 20

        @Environment(\.sizeCategory) var sizeCategory
        @Environment(\.isEnabled) var isEnabled

        let state: Radio.State
        let isChecked: Bool

        func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                indicator(isPressed: configuration.isPressed)
                configuration.label
            }
        }

        func indicator(isPressed: Bool) -> some View {
            indicatorShape
                .strokeBorder(indicatorStrokeColor(isPressed: isPressed), lineWidth: strokeWidth)
                .background(
                    indicatorShape
                        .fill(indicatorBackgroundColor)
                )
                .overlay(
                    indicatorShape
                        .inset(by: -0.5)
                        .stroke(state == .error ? Color.redLight : Color.clear, lineWidth: errorStrokeWidth)
                )
                .overlay(
                    indicatorShape
                        .strokeBorder(indicatorOverlayStrokeColor(isPressed: isPressed), lineWidth: indicatorStrokeWidth)
                )
                .frame(width: size, height: size)
                .animation(.easeOut(duration: 0.2), value: state)
                .animation(.easeOut(duration: 0.15), value: isChecked)
                .alignmentGuide(.firstTextBaseline) { _ in
                    size * 0.75 + 3 * (sizeCategory.controlRatio - 1)
                }
        }

        var indicatorShape: some InsettableShape {
            Circle()
        }

        func indicatorStrokeColor(isPressed: Bool) -> some ShapeStyle {
            switch (isEnabled, isChecked, isPressed) {
                case (true, true, false):       return Color.blueNormal
                case (true, true, true):        return Color.blueLightActive
                case (_, _, _):                 return Color.cloudDark
            }
        }

        var indicatorBackgroundColor: some ShapeStyle {
            switch (isEnabled, isChecked) {
                case (false, false):            return Color.cloudNormal
                case (_, _):                    return Color.clear
            }
        }

        func indicatorOverlayStrokeColor(isPressed: Bool) -> some ShapeStyle {
            switch (state, isPressed) {
                case (.normal, true):           return Color.blueNormal
                case (.error, true):            return Color.redLightActive
                case (.error, false):           return Color.redNormal
                case (_, _):                    return Color.clear
            }
        }

        var size: CGFloat {
            Self.size * sizeCategory.controlRatio
        }

        var strokeWidth: CGFloat {
            (isChecked ? 6 : 2) * sizeCategory.controlRatio
        }

        var errorStrokeWidth: CGFloat {
            3 * sizeCategory.controlRatio
        }

        var indicatorStrokeWidth: CGFloat {
            2 * sizeCategory.controlRatio
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let radioTitle           = Self(rawValue: "orbit.radio.title")
    static let radioDescription     = Self(rawValue: "orbit.radio.description")
}

// MARK: - Previews
struct RadioPreviews: PreviewProvider {

    static let label = "Label"
    static let description = "Additional information<br>for this choice"

    static var previews: some View {
        PreviewWrapper {
            standalone
            states
            indicatorStates
        }
        .padding(.medium)
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        radio(standalone: false, state: .normal, checked: true)
            .previewDisplayName()
    }

    static var states: some View {
        content(standalone: false)
            .previewDisplayName()
    }

    static var indicatorStates: some View {
        content(standalone: false)
            .previewDisplayName()
    }

    static var snapshot: some View {
        content(standalone: false)
            .padding(.medium)
    }

    static func content(standalone: Bool) -> some View {
        HStack(alignment: .top, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .xLarge) {
                radio(standalone: standalone, checked: false)
                radio(standalone: standalone, state: .error, checked: false)
                radio(standalone: standalone, checked: false)
                    .disabled(true)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                radio(standalone: standalone, checked: true)
                radio(standalone: standalone, state: .error, checked: true)
                radio(standalone: standalone, checked: true)
                    .disabled(true)
            }
        }
    }

    static func radio(standalone: Bool, state: Radio.State = .normal, checked: Bool) -> some View {
        StateWrapper(checked) { isChecked in
            Radio(standalone ? "" : label, description: standalone ? "" : description, state: state, isChecked: isChecked)
        }
    }
}

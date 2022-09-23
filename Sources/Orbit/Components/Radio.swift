import SwiftUI

/// Enables users to pick exactly one option from a group.
///
/// Can be also used to display just the radio rounded indicator.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/radio/)
public struct Radio: View {

    let title: String
    let description: String
    let state: State
    let isChecked: Bool
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
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
        .disabled(state == .disabled)
    }

    var labelColor: Text.Color {
        state == .disabled ? .custom(.cloudDarkerHover) : .inkNormal
    }

    var descriptionColor: Text.Color {
        state == .disabled ? .custom(.cloudDarkerHover) : .inkLight
    }
}

// MARK: - Inits
public extension Radio {
    
    /// Creates Orbit Radio component.
    init(
        _ title: String = "",
        description: String = "",
        state: State = .normal,
        isChecked: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.description = description
        self.state = state
        self.isChecked = isChecked
        self.action = action
    }
}

// MARK: - Types
public extension Radio {
    
    enum State {
        case normal
        case error
        case disabled
    }
}

// MARK: - ButtonStyle
extension Radio {

    /// Button style wrapper for radio input.
    /// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ButtonStyle: SwiftUI.ButtonStyle {

        public static let size: CGFloat = 20

        @Environment(\.sizeCategory) var sizeCategory

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
            switch (state, isChecked, isPressed) {
                case (.normal, true, false), (.error, true, false):     return Color.blueNormal
                case (.normal, true, true), (.error, true, true):       return Color.blueLightActive
                case (_, _, _):                                         return Color.cloudDarker
            }
        }

        var indicatorBackgroundColor: some ShapeStyle {
            switch (state, isChecked) {
                case (.disabled, false):                    return Color.cloudNormal
                case (_, _):                                return Color.clear
            }
        }

        func indicatorOverlayStrokeColor(isPressed: Bool) -> some ShapeStyle {
            switch (state, isPressed) {
                case (.normal, true):                       return Color.blueNormal
                case (.error, true):                        return Color.redLightActive
                case (.error, false):                       return Color.redNormal
                case (_, _):                                return Color.clear
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

// MARK: - Previews
struct RadioPreviews: PreviewProvider {

    static let label = "Label"
    static let description = "Additional information<br>for this choice"

    static var previews: some View {
        PreviewWrapper {
            standalone
            content(standalone: false)
            content(standalone: true)
        }
        .padding(.medium)
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        radio(standalone: false, state: .normal, checked: true)
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .large) {
            content(standalone: false)
            content(standalone: true)
        }
    }

    static var snapshot: some View {
        content(standalone: false)
            .padding(.medium)
    }

    static func content(standalone: Bool) -> some View {
        HStack(alignment: .top, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .xLarge) {
                radio(standalone: standalone, state: .normal, checked: false)
                radio(standalone: standalone, state: .error, checked: false)
                radio(standalone: standalone, state: .disabled, checked: false)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                radio(standalone: standalone, state: .normal, checked: true)
                radio(standalone: standalone, state: .error, checked: true)
                radio(standalone: standalone, state: .disabled, checked: true)
            }
        }
    }

    static func radio(standalone: Bool, state: Radio.State, checked: Bool) -> some View {
        StateWrapper(initialState: checked) { isSelected in
            Radio(standalone ? "" : label, description: standalone ? "" : description, state: state, isChecked: isSelected.wrappedValue) {
                isSelected.wrappedValue.toggle()
            }
        }
    }
}

struct RadioDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        RadioPreviews.standalone
    }
}

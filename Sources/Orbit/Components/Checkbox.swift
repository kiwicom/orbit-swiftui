import SwiftUI

/// Enables users to pick multiple options from a group.
///
/// Can be also used to display just the checkbox with no label or description.
/// 
/// - Note: [Orbit definition](https://orbit.kiwi/components/checkbox/)
public struct Checkbox: View {

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
                            .accessibility(.checkboxTitle)
                        Text(description, size: .small, color: descriptionColor)
                            .accessibility(.checkboxDescription)
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
public extension Checkbox {
    
    /// Creates Orbit Checkbox component.
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
public extension Checkbox {
    
    enum State {
        case normal
        case error
        case disabled
    }
}

// MARK: - ButtonStyle
public extension Checkbox {

    /// Button style wrapper for checkbox input.
    /// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ButtonStyle: SwiftUI.ButtonStyle {

        public static let size: CGFloat = 20

        @Environment(\.sizeCategory) var sizeCategory

        let state: Checkbox.State
        let isChecked: Bool

        public func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                indicator(isPressed: configuration.isPressed)
                configuration.label
            }
        }

        func indicator(isPressed: Bool) -> some View {
            shape
                .strokeBorder(
                    indicatorStrokeColor(isPressed: isPressed),
                    lineWidth: indicatorStrokeWidth
                )
                .background(
                    shape
                        .fill(indicatorBackgroundColor(isPressed: isPressed))
                )
                .overlay(
                    Icon(.check, size: .small, color: .whiteNormal)
                        .foregroundColor(state == .disabled ? .cloudNormal : .whiteNormal)
                        .opacity(isChecked ? 1 : 0)
                )
                .overlay(
                    shape
                        .inset(by: -inset)
                        .stroke(state == .error ? Color.redLight : Color.clear, lineWidth: errorStrokeWidth)
                )
                .overlay(
                    shape
                        .strokeBorder(indicatorOverlayStrokeColor(isPressed: isPressed), lineWidth: indicatorStrokeWidth)
                )
                .frame(width: size, height: size)
                .animation(.easeOut(duration: 0.2), value: state)
                .animation(.easeOut(duration: 0.15), value: isChecked)
                .alignmentGuide(.firstTextBaseline) { _ in
                    size * 0.75 + 3 * (sizeCategory.controlRatio - 1)
                }
        }

        var shape: some InsettableShape {
            RoundedRectangle(cornerRadius: BorderRadius.default * sizeCategory.controlRatio, style: .continuous)
        }

        func indicatorStrokeColor(isPressed: Bool) -> some ShapeStyle {
            switch (state, isChecked, isPressed) {
                case (.normal, true, false), (.error, true, false):     return Color.blueNormal
                case (.normal, true, true), (.error, true, true):       return Color.blueLightActive
                case (_, _, _):                                         return Color.cloudDarker
            }
        }

        func indicatorBackgroundColor(isPressed: Bool) -> some ShapeStyle {
            switch (state, isChecked, isPressed) {
                case (.normal, true, false), (.error, true, false):     return Color.blueNormal
                case (.normal, true, true), (.error, true, true):       return Color.blueLightActive
                case (.disabled, false, _):                             return Color.cloudNormal
                case (.disabled, true, _):                              return Color.cloudDarker
                case (_, _, _):                                         return Color.clear
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

        var inset: CGFloat {
            0.5 * sizeCategory.controlRatio
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
struct CheckboxPreviews: PreviewProvider {

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
        StateWrapper(initialState: true) { isSelected in
            checkbox(standalone: false, state: .normal, checked: isSelected.wrappedValue)
        }
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
                checkbox(standalone: standalone, state: .normal, checked: false)
                checkbox(standalone: standalone, state: .error, checked: false)
                checkbox(standalone: standalone, state: .disabled, checked: false)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                checkbox(standalone: standalone, state: .normal, checked: true)
                checkbox(standalone: standalone, state: .error, checked: true)
                checkbox(standalone: standalone, state: .disabled, checked: true)
            }
        }
    }

    static func checkbox(standalone: Bool, state: Checkbox.State, checked: Bool) -> some View {
        StateWrapper(initialState: checked) { isSelected in
            Checkbox(standalone ? "" : label, description: standalone ? "" : description, state: state, isChecked: isSelected.wrappedValue) {
                isSelected.wrappedValue.toggle()
            }
        }
    }
}

struct CheckboxDynamicTypePreviews: PreviewProvider {

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
        CheckboxPreviews.standalone
    }
}

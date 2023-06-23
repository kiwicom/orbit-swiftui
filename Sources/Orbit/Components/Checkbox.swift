import SwiftUI

/// Enables users to pick multiple options from a group.
///
/// Can be also used to display just the checkbox with no label or description.
/// 
/// - Note: [Orbit definition](https://orbit.kiwi/components/checkbox/)
public struct Checkbox: View {

    @Environment(\.isEnabled) var isEnabled
    @Environment(\.textColor) var textColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    let title: String
    let description: String
    let state: State
    @Binding var isChecked: Bool

    public var body: some View {
        SwiftUI.Button(
            action: {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                isChecked.toggle()
            },
            label: {
                if title.isEmpty == false || description.isEmpty == false {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(title)
                            .textColor(labelColor)
                            .fontWeight(.medium)
                            .accessibility(.checkboxTitle)
                        
                        Text(description)
                            .textSize(.small)
                            .textColor(descriptionColor)
                            .accessibility(.checkboxDescription)
                    }
                }
            }
        )
        .buttonStyle(
            ButtonStyle(state: state, isChecked: isChecked)
        )
    }

    var labelColor: Color {
        isEnabled
            ? textColor ?? .inkDark
            : .cloudDarkHover
    }

    var descriptionColor: Color {
        isEnabled
            ? .inkNormal
            : .cloudDarkHover
    }
}

// MARK: - Inits
public extension Checkbox {

    /// Creates Orbit Checkbox component.
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
public extension Checkbox {
    
    enum State {
        case normal
        case error
    }
}

// MARK: - ButtonStyle
public extension Checkbox {

    /// Button style wrapper for checkbox input.
    /// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ButtonStyle: SwiftUI.ButtonStyle {

        public static let size: CGFloat = 20

        @Environment(\.sizeCategory) var sizeCategory
        @Environment(\.isEnabled) var isEnabled

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
                    Icon(.check)
                        .iconSize(.small)
                        .textColor(isEnabled ? .whiteNormal : .cloudNormal)
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
            switch (isEnabled, isChecked, isPressed) {
                case (true, true, false):       return .blueNormal
                case (true, true, true):        return .blueLightActive
                case (_, _, _):                 return .cloudDark
            }
        }

        func indicatorBackgroundColor(isPressed: Bool) -> some ShapeStyle {
            switch (isEnabled, isChecked, isPressed) {
                case (true, true, false):       return .blueNormal
                case (true, true, true):        return .blueLightActive
                case (false, false, _):         return .cloudNormal
                case (false, true, _):          return .cloudDark
                case (_, _, _):                 return .clear
            }
        }

        func indicatorOverlayStrokeColor(isPressed: Bool) -> some ShapeStyle {
            switch (state, isPressed) {
                case (.normal, true):           return .blueNormal
                case (.error, true):            return .redLightActive
                case (.error, false):           return .redNormal
                case (_, _):                    return .clear
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

// MARK: - Identifiers
public extension AccessibilityID {

    static let checkboxTitle        = Self(rawValue: "orbit.checkbox.title")
    static let checkboxDescription  = Self(rawValue: "orbit.checkbox.description")
}

// MARK: - Previews
struct CheckboxPreviews: PreviewProvider {

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
        StateWrapper(true) { isSelected in
            checkbox(standalone: false, state: .normal, checked: isSelected.wrappedValue)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        content(standalone: false)
            .padding(.medium)
    }

    static var states: some View {
        content(standalone: false)
            .previewDisplayName()
    }

    static var indicatorStates: some View {
        content(standalone: true)
            .previewDisplayName()
    }

    static func content(standalone: Bool) -> some View {
        HStack(alignment: .top, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .xLarge) {
                checkbox(standalone: standalone, checked: false)
                checkbox(standalone: standalone, state: .error, checked: false)
                checkbox(standalone: standalone, checked: false)
                    .disabled(true)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                checkbox(standalone: standalone, checked: true)
                checkbox(standalone: standalone, state: .error, checked: true)
                checkbox(standalone: standalone, checked: true)
                    .disabled(true)
            }
        }
    }

    static func checkbox(standalone: Bool, state: Checkbox.State = .normal, checked: Bool) -> some View {
        StateWrapper(checked) { $isSelected in
            Checkbox(standalone ? "" : label, description: standalone ? "" : description, state: state, isChecked: $isSelected)
        }
    }
}

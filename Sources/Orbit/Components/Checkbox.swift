import SwiftUI

/// Orbit input component that displays a selectable option to pick from multiple selectable options. 
/// A counterpart of the native `SwiftUI.Toggle` with `checkbox` style applied.
///
/// A ``Checkbox`` consists of a title, description and the checkbox indicator.
///
/// ```swift
/// Checkbox("Free", isChecked: $isFree)
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier:
/// 
/// ```swift
/// Checkbox(isChecked: $isFree)
///     .disabled()
/// ```
///
/// Before the selection is changed, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Customizing appearance
/// 
/// The title color can be modified by ``textColor(_:)`` modifier:
/// 
/// ```swift
/// Checkbox("Free", isChecked: $isFree)
///     .textColor(.blueNormal)
/// ```
/// 
/// ### Layout
/// 
/// When the provided textual content is empty, the component results in a standalone control.
/// 
/// ```swift
/// Checkbox(isChecked: $isFree)
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/checkbox/)
public struct Checkbox: View {

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let title: String
    private let description: String
    private let state: State
    @Binding private var isChecked: Bool

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }
            
            isChecked.toggle()
        } label: {
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
        .buttonStyle(
            CheckboxButtonStyle(state: state, isChecked: isChecked)
        )
    }

    private var labelColor: Color {
        isEnabled
            ? textColor ?? .inkDark
            : .cloudDarkHover
    }

    private var descriptionColor: Color {
        isEnabled
            ? .inkNormal
            : .cloudDarkHover
    }
}

// MARK: - Inits
public extension Checkbox {

    /// Creates Orbit ``Checkbox`` component.
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
    
    /// A state of Orbit ``Checkbox``.
    enum State {
        case normal
        case error
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

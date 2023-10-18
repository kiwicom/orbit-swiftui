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
            CheckboxButtonStyle(state: state, isChecked: isChecked)
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

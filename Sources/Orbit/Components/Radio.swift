import SwiftUI

/// Enables users to pick exactly one option from a group.
///
/// Can be also used to display just the radio rounded indicator.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/radio/)
public struct Radio: View {

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    let title: String
    let description: String
    let state: State
    @Binding var isChecked: Bool

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
                        .accessibility(.radioTitle)
                    
                    Text(description)
                        .textSize(.small)
                        .textColor(descriptionColor)
                        .accessibility(.radioDescription)
                }
            }
        }
        .buttonStyle(
            RadioButtonStyle(state: state, isChecked: isChecked)
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

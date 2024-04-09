import SwiftUI

/// Orbit input component that displays a single selectable option to pick from a group. 
/// A counterpart of the native `SwiftUI.Picker` with `radioGroup` style applied.
///
/// A ``Radio`` consists of a title, description and the radio indicator.
///
/// ```swift
/// Radio("Free", isChecked: $isFree)
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier:
/// 
/// ```swift
/// Radio(isChecked: $isFree)
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
/// Radio("Free", isChecked: $isFree)
///     .textColor(.blueNormal)
/// ```
///
/// ### Layout
/// 
/// When the provided textual content is empty, the component results in a standalone control.
/// 
/// ```swift
/// Radio(isChecked: $isFree)
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/radio/)
public struct Radio<Title: View, Description: View>: View {

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let state: RadioState
    @Binding private var isChecked: Bool
    @ViewBuilder private let title: Title
    @ViewBuilder private let description: Description

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }
            
            isChecked.toggle()
        } label: {
            if title.isEmpty == false || description.isEmpty == false {
                VStack(alignment: .leading, spacing: 1) {
                    title
                        .textColor(labelColor)
                        .textFontWeight(.medium)
                        .accessibility(.radioTitle)
                    
                    description
                        .textSize(.small)
                        .textColor(descriptionColor)
                        .accessibility(.radioDescription)
                }
            }
        }
        .buttonStyle(
            RadioButtonStyle(state: state, isChecked: isChecked)
        )
        .accessibility(.radio)
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
    
    /// Creates Orbit ``Radio`` component with custom content.
    public init(
        isChecked: Binding<Bool>,
        state: RadioState = .normal,
        @ViewBuilder title: () -> Title = { EmptyView() },
        @ViewBuilder description: () -> Description = { EmptyView() }
    ) {
        self._isChecked = isChecked
        self.state = state
        self.title = title()
        self.description = description()
    }
}

// MARK: - Convenience Inits
public extension Radio where Title == Text, Description == Text {

    /// Creates Orbit ``Radio`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        isChecked: Binding<Bool>,
        state: RadioState = .normal
    ) {
        self.init(isChecked: isChecked, state: state) {
            Text(title)
        } description: {
            Text(description)
        }
    }
    
    /// Creates Orbit ``Radio`` component with localizable texts.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        isChecked: Binding<Bool>,
        state: RadioState = .normal,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        titleComment: StaticString? = nil        
    ) {
        self.init(isChecked: isChecked, state: state) {
            Text(title, tableName: tableName, bundle: bundle)
        } description: {
            Text(description, tableName: tableName, bundle: bundle)
        }
    }
}

// MARK: - Types

/// A state of Orbit ``Radio``.
public enum RadioState {
    case normal
    case error
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let radio                = Self(rawValue: "orbit.radio")
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

    static func radio(standalone: Bool, state: RadioState = .normal, checked: Bool) -> some View {
        StateWrapper(checked) { isChecked in
            Radio(standalone ? "" : label, description: standalone ? "" : description, isChecked: isChecked, state: state)
        }
    }
}

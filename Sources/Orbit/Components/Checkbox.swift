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
public struct Checkbox<Title: View, Description: View>: View {

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let state: CheckboxState
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
                        .accessibility(.checkboxTitle)
                    
                    description
                        .textSize(.small)
                        .textColor(descriptionColor)
                        .accessibility(.checkboxDescription)
                }
            }
        }
        .buttonStyle(
            CheckboxButtonStyle(state: state, isChecked: isChecked)
        )
        .accessibility(.checkbox)
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
    
    /// Creates Orbit ``Checkbox`` component with custom content.
    public init(
        isChecked: Binding<Bool>,
        state: CheckboxState = .normal,
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
public extension Checkbox where Title == Text, Description == Text {

    /// Creates Orbit ``Checkbox`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        isChecked: Binding<Bool>,
        state: CheckboxState = .normal
    ) {
        self.init(isChecked: isChecked, state: state) {
            Text(title)
        } description: {
            Text(description)
        }
    }
    
    /// Creates Orbit ``Checkbox`` component with localizable texts.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        isChecked: Binding<Bool>,
        state: CheckboxState = .normal,
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

/// A state of Orbit ``Checkbox``.
public enum CheckboxState {
    case normal
    case error
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let checkbox             = Self(rawValue: "orbit.checkbox")
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

    static func checkbox(standalone: Bool, state: CheckboxState = .normal, checked: Bool) -> some View {
        StateWrapper(checked) { $isSelected in
            Checkbox(standalone ? "" : label, description: standalone ? "" : description, isChecked: $isSelected, state: state)
        }
    }
}

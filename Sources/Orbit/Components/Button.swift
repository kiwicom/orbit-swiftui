import SwiftUI

/// Orbit component that displays a primary control that initiates an action. 
/// A counterpart of the native `SwiftUI.Button` with `borderedProminent` button style.
///
/// A ``Button`` consists of a label and up to two icons.
///
/// ```swift
/// Button("Continue", icon: .chevronForward) {
///     // Tap action 
/// }
/// ```
/// 
/// ### Customizing appearance
///
/// The label and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
///
/// ```swift
/// Button("Continue") {
///     // Tap action
/// }
/// .textColor(.blueLight)
/// .iconColor(.blueNormal)
/// .iconSize(.large)
/// ```
/// 
/// When type is set to ``ButtonType/status(_:isSubtle:)`` with a `nil` value, 
/// the default ``Status/info`` status can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// Button("Delete", type: .status(nil)) {
///     // Tap action
/// }
/// .status(.critical)
/// ```
///
/// Before the action is triggered, a relevant haptic feedback, based on the `Button` type, is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier.
/// The default ``ButtonSize/regular`` size can be modified by a ``buttonSize(_:)`` modifier.
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/button/)
public struct Button<LeadingIcon: View, Label: View, TrailingIcon: View>: View, PotentiallyEmptyView {

    @Environment(\.suppressButtonStyle) private var suppressButtonStyle

    private let type: ButtonType
    private let action: () -> Void
    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let label: Label
    @ViewBuilder private let trailingIcon: TrailingIcon

    public var body: some View {
        if suppressButtonStyle {
            button
        } else {
            button
                .buttonStyle(
                    OrbitButtonStyle(type: type) {
                        leadingIcon
                    } trailingIcon: {
                        trailingIcon
                    }
                )
        }
    }

    @ViewBuilder private var button: some View {
        if isEmpty == false {
            SwiftUI.Button() {
                action()
            } label: {
                label
            }
        }
    }

    var isEmpty: Bool {
        label.isEmpty && leadingIcon.isEmpty && trailingIcon.isEmpty
    }
    
    /// Creates Orbit ``Button`` component with custom content.
    public init(
        type: ButtonType = .primary,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label,
        @ViewBuilder icon: () -> LeadingIcon = { EmptyView() },
        @ViewBuilder disclosureIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.type = type
        self.action = action
        self.label = label()
        self.leadingIcon = icon()
        self.trailingIcon = disclosureIcon()
    }
}

// MARK: - Convenience Inits
public extension Button where Label == Text, LeadingIcon == Icon, TrailingIcon == Icon {

    /// Creates Orbit ``Button`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        type: ButtonType = .primary,
        action: @escaping () -> Void
    ) {
        self.init(type: type) {
            action()
        } label: {
            Text(label)
        } icon: {
            Icon(icon)
        } disclosureIcon: {
            Icon(disclosureIcon)
        }
    }
    
    /// Creates Orbit ``Button`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        type: ButtonType = .primary,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        action: @escaping () -> Void
    ) {
        self.init(type: type) {
            action()
        } label: {
            Text(label, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        } disclosureIcon: {
            Icon(disclosureIcon)
        }
    }
}

// MARK: - Types

/// A predefined type of Orbit ``Button``.
public enum ButtonType {
    case primary
    case primarySubtle
    case secondary
    case critical
    case criticalSubtle
    case status(Status?, isSubtle: Bool = false)
}

// MARK: - Previews
struct ButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            combinations
            sizing

            styles
            statuses
            gradients
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Button("Button", icon: .grid, action: {})
            
            // EmptyView
            Group {
                Button(action: {})
                Button("", action: {})
                
                Button {
                    // No action
                } label: {
                    Text("")
                } icon: {
                    Icon(nil)
                } disclosureIcon: {
                    Icon(nil)
                }
            }
            .border(.redNormal)
            
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var combinations: some View {
        VStack(spacing: .medium) {
            Button("Button", icon: .grid, action: {})
            Button("Button", icon: .grid, disclosureIcon: .grid, action: {})
            Button("Button", action: {})
            Button(icon: .grid, action: {})
            Button(icon: .grid, action: {})
                .idealSize()
            Button(icon: .arrowUp, action: {})
                .idealSize()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                Button(" ", action: {})
                Button("Button", action: {})
                Button("Button", icon: .grid, action: {})
                Button("Button\nmultiline", icon: .grid, action: {})
                Button(icon: .grid, action: {})
                Group {
                    Button("Button small", action: {})
                    Button("Button small", icon: .grid, action: {})
                    Button(icon: .grid, action: {})
                    Button("Button\nmultiline", action: {})
                }
                .buttonSize(.compact)
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var styles: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var statuses: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var gradients: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
                .backgroundStyle(Gradient.bundleBasic.background, active: Gradient.bundleBasic.startColor)
                .previewDisplayName("Bundle Basic")
            buttons(.primary)
                .backgroundStyle(Gradient.bundleMedium.background, active: Gradient.bundleMedium.startColor)
                .previewDisplayName("Bundle Medium")
            buttons(.primary)
                .backgroundStyle(Gradient.bundleTop.background, active: Gradient.bundleTop.startColor)
                .previewDisplayName("Bundle Top")
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button {
                // No action
            } label: {
              Text("Button with SF Symbol")  
            } icon: {
                Icon("info.circle.fill")
            }
            
            Button(type: .secondary) {
                // No action
            } label: {
                Text("Button with SF Symbol")  
            } icon: {
                CountryFlag("us")
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .padding(.medium)
    }

    @ViewBuilder static func buttons(_ type: ButtonType) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                Button("Label", icon: .grid, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            .buttonSize(.compact)
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, isSubtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ type: ButtonType) -> some View {
        HStack(spacing: .xSmall) {
            Button("Label", type: type, action: {})
            Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
            Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
            Button(icon: .grid, type: type, action: {})

            Spacer(minLength: 0)
        }
        .buttonSize(.compact)
    }
}

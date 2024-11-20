import SwiftUI

/// Orbit component that displays a less important control that initiates an action. 
/// A counterpart of the native `SwiftUI.Button` with `plain` button style.
///
/// A ``ButtonLink`` consists of a label and up to two icons.
///
/// ```swift
/// ButtonLink("Edit", icon: .edit) {
///     // Tap action
/// }
/// ```
///
/// ### Customizing appearance
///
/// The icon color can be modified by ``iconColor(_:)`` modifier.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
/// 
/// ```swift
/// ButtonLink("More", icon: .informationCircle) {
///     // Tap action
/// }
/// .iconColor(.blueNormal)
/// .iconSize(.large)
/// ```
/// 
/// When type is set to ``ButtonLinkType/status(_:)`` with a `nil` value, the default ``Status/info`` status can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// ButtonLink("Delete", type: .status(nil)) {
///     // Tap action
/// }
/// .status(.critical)
/// ```
///
/// Before the action is triggered, a relevant haptic feedback, based on the `ButtonLink` type, is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier or by specifying the ``ButtonSize/compact`` size.
/// The default ``ButtonSize/regular`` size can be modified by a ``buttonSize(_:)`` modifier.
///
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/buttonlink/)
public struct ButtonLink<LeadingIcon: View, Label: View, TrailingIcon: View>: View, PotentiallyEmptyView {

    @Environment(\.suppressButtonStyle) private var suppressButtonStyle

    private let type: ButtonLinkType
    private let action: () -> Void
    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let label: Label
    @ViewBuilder private let trailingIcon: TrailingIcon

    public var body: some View {
        if isEmpty == false {
            if suppressButtonStyle {
                button
            } else {
                button
                    .buttonStyle(
                        OrbitButtonLinkButtonStyle(type: type) {
                            leadingIcon
                        } trailingIcon: {
                            trailingIcon
                        }
                    )
            }
        }
    }

    @ViewBuilder private var button: some View {
        SwiftUI.Button {
            action()
        } label: {
            label
        }
    }

    var isEmpty: Bool {
        label.isEmpty && leadingIcon.isEmpty && trailingIcon.isEmpty
    }
    
    /// Creates Orbit ``ButtonLink`` component with custom content.
    public init(
        type: ButtonLinkType = .primary,
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
public extension ButtonLink where Label == Text, LeadingIcon == Orbit.Icon, TrailingIcon == Orbit.Icon {

    /// Creates Orbit ``ButtonLink`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        type: ButtonLinkType = .primary,
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
    
    /// Creates Orbit ``ButtonLink`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        type: ButtonLinkType = .primary,
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

/// A predefined type of Orbit ``ButtonLink``.
public enum ButtonLinkType: Equatable, Sendable {
    case primary
    case critical
    case prominent
    case status(_ status: Status?)
}

// MARK: - Previews
struct ButtonLinkPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            formatted
            iconOnly
            styles
            statuses
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(alignment: .leading, spacing: 0) {
            ButtonLink("ButtonLink", icon: .grid, action: {})
                .buttonSize(.regular)
            ButtonLink("ButtonLink", icon: .grid, disclosureIcon: .grid, type: .critical, action: {})
                .buttonSize(.regular)
            ButtonLink("ButtonLink", action: {})
            
            // EmptyView
            Group {
                ButtonLink(action: {})
                ButtonLink("", action: {})
                
                ButtonLink {
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
        .buttonSize(.compact)
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Group {
                ButtonLink("ButtonLink", action: {})
                    .buttonSize(.regular)
                ButtonLink("ButtonLink", icon: .grid, action: {})
                    .buttonSize(.regular)
                ButtonLink("ButtonLink Compact", action: {})
                    .buttonSize(.compact)
                ButtonLink("ButtonLink Compact", icon: .grid, action: {})
                    .buttonSize(.compact)
            }
            .border(.cloudNormal)
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", type: .primary, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, action: {})
                ButtonLink("ButtonLink Prominent", type: .prominent, action: {})
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", icon: .accommodation, type: .primary, action: {})
                ButtonLink("ButtonLink Critical", icon: .alertCircle, type: .critical, action: {})
                ButtonLink("ButtonLink Prominent", icon: .alertCircle, type: .prominent, action: {})
            }
        }
        .buttonSize(.compact)
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var statuses: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", icon: .informationCircle, type: .status(.info) , action: {})
            ButtonLink("ButtonLink Success", icon: .checkCircle, type: .status(.success), action: {})
            ButtonLink("ButtonLink Warning", icon: .alert, type: .status(.warning), action: {})
            ButtonLink("ButtonLink Critical", icon: .alertCircle, type: .status(.critical), action: {})
        }
        .buttonSize(.compact)
        .padding(.medium)
        .previewDisplayName()
    }

    static var formatted: some View {
        ButtonLink(
            "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
            icon: .kiwicom,
            action: {}
        )
        .buttonSize(.compact)
        .textAccentColor(Status.success.darkColor)
        .textLinkColor(.status(.critical))
        .padding(.medium)
        .previewDisplayName()
    }

    static var iconOnly: some View {
        ButtonLink(icon: .kiwicom, action: {})
            .buttonSize(.compact)
            .padding(.medium)
            .previewDisplayName()
    }
}

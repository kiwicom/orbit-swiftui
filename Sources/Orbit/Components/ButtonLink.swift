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
public struct ButtonLink<LeadingIcon: View, TrailingIcon: View>: View, PotentiallyEmptyView {

    @Environment(\.suppressButtonStyle) private var suppressButtonStyle

    private let label: String
    private let type: ButtonLinkType
    private let action: () -> Void
    @ViewBuilder private let leadingIcon: LeadingIcon
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
        SwiftUI.Button() {
            action()
        } label: {
            Text(label)
        }
    }

    var isEmpty: Bool {
        label.isEmpty && leadingIcon.isEmpty && trailingIcon.isEmpty
    }
}

// MARK: - Inits
public extension ButtonLink {

    /// Creates Orbit ``ButtonLink`` component.
    init(
        _ label: String = "",
        type: ButtonLinkType = .primary,
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        action: @escaping () -> Void
    ) where LeadingIcon == Orbit.Icon, TrailingIcon == Orbit.Icon  {
        self.init(label, type: type) {
            action()
        } icon: {
            Icon(icon)
        } disclosureIcon: {
            Icon(disclosureIcon)
        }
    }

    /// Creates Orbit ``ButtonLink`` component with custom icons.
    init(
        _ label: String = "",
        type: ButtonLinkType = .primary,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> LeadingIcon,
        @ViewBuilder disclosureIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.label = label
        self.type = type
        self.action = action
        self.leadingIcon = icon()
        self.trailingIcon = disclosureIcon()
    }
}

// MARK: - Types

/// A predefined type of Orbit ``ButtonLink``.
public enum ButtonLinkType: Equatable {
    case primary
    case critical
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
        VStack(spacing: 0) {
            ButtonLink("ButtonLink", icon: .grid, action: {})
                .buttonSize(.regular)
            ButtonLink("ButtonLink", type: .critical, action: {})
                .buttonSize(.regular)
            ButtonLink("ButtonLink", action: {})
            ButtonLink("", action: {}) // EmptyView
            ButtonLink(action: {})   // EmptyView
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
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", type: .primary, icon: .accommodation, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, icon: .alertCircle, action: {})
            }
        }
        .buttonSize(.compact)
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var statuses: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", type: .status(.info), icon: .informationCircle, action: {})
            ButtonLink("ButtonLink Success", type: .status(.success), icon: .checkCircle, action: {})
            ButtonLink("ButtonLink Warning", type: .status(.warning), icon: .alert, action: {})
            ButtonLink("ButtonLink Critical", type: .status(.critical), icon: .alertCircle, action: {})
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

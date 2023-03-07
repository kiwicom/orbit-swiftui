import SwiftUI

public enum AlertButtons {
    case none
    case primary(Button.Content)
    case secondary(Button.Content)
    case primaryAndSecondary(Button.Content, Button.Content)

    public var isVisible: Bool {
        switch self {
            case .primary, .secondary, .primaryAndSecondary:    return true
            case .none:                                         return false
        }
    }
}

/// Breaks the main user flow to present information.
///
/// There are times when just simple information isn’t enough and the user needs
/// to take additional steps to resolve the problem or get additional details.
///
/// In such cases, provide additional actions for your message.
/// Alerts use special status buttons to match the button color with the alert color.
///
/// Use at most two actions in each Alert: one primary and one subtle.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/alert/)
/// - Important: Component expands horizontally unless prevented by the `fixedSize` modifier.
public struct Alert<Content: View>: View {

    let style: AlertStyle
    let title: String
    let description: String
    let iconContent: Icon.Content
    let buttons: AlertButtons
    let status: Status
    let isSuppressed: Bool
    let descriptionLinkAction: TextLink.Action
    @ViewBuilder let customContent: Content

    public var body: some View {
        content
            .background(background)
            .cornerRadius(BorderRadius.default)
            .accessibilityElement(children: .contain)
    }

    @ViewBuilder var content: some View {
        switch style {
            case .default:  defaultContent
            case .inline:   inlineContent
        }
    }

    @ViewBuilder var defaultContent: some View {
        HStack(alignment: .top, spacing: .xSmall) {
            icon
                .padding(.leading, -.xxSmall)

            VStack(alignment: .leading, spacing: .medium) {
                defaultHeader
                customContent
                defaultButtons
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.medium)
    }

    @ViewBuilder var inlineContent: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            inlineHeader

            if isInlineHeaderEmpty == false, isInlineButtonVisible {
                Spacer(minLength: 0)
            }

            inlineButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder var defaultHeader: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(alignment: .leading, spacing: .xxSmall) {
                titleView
                Text(description, linkColor: .secondary, linkAction: descriptionLinkAction)
                    .accessibility(.alertDescription)
            }
        }
    }

    @ViewBuilder var inlineHeader: some View {
        if isInlineHeaderEmpty == false {
            HStack(alignment: .top, spacing: .xSmall) {
                icon
                titleView
            }
            .padding(.vertical, 14)
            .padding(.horizontal, .small)
            .padding(.top, 3)
        }
    }

    @ViewBuilder var icon: some View {
        Icon(content: iconContent)
            .foregroundColor(status.color)
            .accessibility(.alertIcon)
    }

    @ViewBuilder var titleView: some View {
        Text(title, weight: .bold)
            .accessibility(.alertTitle)
    }

    @ViewBuilder var defaultButtons: some View {
        switch buttons {
            case .primary, .secondary, .primaryAndSecondary:
                // Keeping the identity of buttons for correct animations
                HStack(alignment: .top, spacing: .small) {
                    switch buttons {
                        case .primary(let primaryButton),
                             .primaryAndSecondary(let primaryButton, _):
                            Button(primaryButton.label, style: primaryButtonStyle, size: .small, action: primaryButton.action)
                                .accessibility(.alertButtonPrimary)
                        case .none, .secondary:
                            EmptyView()
                    }

                    switch buttons {
                        case .secondary(let secondaryButton),
                             .primaryAndSecondary(_, let secondaryButton):
                            Button(secondaryButton.label, style: secondaryButtonStyle, size: .small, action: secondaryButton.action)
                                .accessibility(.alertButtonSecondary)
                        case .none, .primary:
                            EmptyView()
                    }
                }
            case .none:
                EmptyView()
        }
    }

    @ViewBuilder var inlineButton: some View {
        switch buttons {
            case .primary(let button),
                 .primaryAndSecondary(let button, _):
                Button(button.label, style: primaryButtonStyle, size: .small, action: button.action)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.xSmall)
                    .padding(.top, 3)
                    .accessibility(.alertButtonPrimary)
            case .none, .secondary:
                EmptyView()
        }
    }

    @ViewBuilder var background: some View {
        backgroundColor
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .strokeBorder(strokeColor, lineWidth: 1)
            )
            .overlay(
                status.color
                    .frame(height: 3),
                alignment: .top
            )
    }
    
    var backgroundColor: Color {
        switch (status, isSuppressed) {
            case (_, true):             return .cloudLight
            case (.info, _):            return .blueLight
            case (.success, _):         return .greenLight
            case (.warning, _):         return .orangeLight
            case (.critical, _):        return .redLight
        }
    }

    var strokeColor: Color {
        switch (status, isSuppressed) {
            case (_, true):             return .cloudLightHover
            case (.info, _):            return .blueLightHover
            case (.success, _):         return .greenLightHover
            case (.warning, _):         return .orangeLightHover
            case (.critical, _):        return .redLightHover
        }
    }

    var textColor: UIColor {
        switch status {
            case .info:     return .blueDark
            case .success:  return .greenDark
            case .warning:  return .orangeDark
            case .critical: return .redDark
        }
    }

    var primaryButtonStyle: Orbit.Button.Style {
        .status(status, subtle: false)
    }

    var secondaryButtonStyle: Orbit.Button.Style {
        isSuppressed
            ? .secondary
            : .status(status, subtle: true)
    }

    var isInlineHeaderEmpty: Bool {
        iconContent.isEmpty && title.isEmpty
    }

    var isInlineButtonVisible: Bool {
        switch buttons {
            case .primary, .primaryAndSecondary: return true
            case .secondary, .none:              return false
        }
    }
}

// MARK: - Inits
public extension Alert {
    
    /// Creates Orbit Alert component including custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        buttons: AlertButtons = .none,
        status: Status = .info,
        isSuppressed: Bool = false,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = icon
        self.buttons = buttons
        self.status = status
        self.isSuppressed = isSuppressed
        self.style = .default
        self.descriptionLinkAction = descriptionLinkAction
        self.customContent = content()
    }
    
    /// Creates Orbit Alert component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        buttons: AlertButtons = .none,
        status: Status = .info,
        isSuppressed: Bool = false,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in }
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            buttons: buttons,
            status: status,
            isSuppressed: isSuppressed,
            descriptionLinkAction: descriptionLinkAction,
            content: { EmptyView() }
        )
    }

    /// Creates Orbit Alert (inline) component.
    init(
        _ title: String = "",
        icon: Icon.Content = .none,
        button: Button.Content? = nil,
        status: Status = .info,
        isSuppressed: Bool = false
    ) where Content == EmptyView {
        self.title = title
        self.description = ""
        self.iconContent = icon
        self.buttons = button.map { .primary($0) } ?? .none
        self.status = status
        self.isSuppressed = isSuppressed
        self.style = .inline
        self.descriptionLinkAction = { _, _ in }
        self.customContent = EmptyView()
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    
    static let alertButtonPrimary       = Self(rawValue: "orbit.alert.button.primary")
    static let alertButtonSecondary     = Self(rawValue: "orbit.alert.button.secondary")
    static let alertTitle               = Self(rawValue: "orbit.alert.title")
    static let alertIcon                = Self(rawValue: "orbit.alert.icon")
    static let alertDescription         = Self(rawValue: "orbit.alert.description")
}

// MARK: - Styles
enum AlertStyle {
    case `default`
    case inline
}

// MARK: - Previews
struct AlertPreviews: PreviewProvider {

    static let title = "Title"
    static let description = """
        The main description message of this Alert component should be placed here. If you need to use TextLink \
        in this component, please do it by using <a href="..">Normal Underline text style</a>.

        Description message can be <strong>formatted</strong>, but if more <ref>customizaton</ref> is needed a custom \
        description content can be provided instead.
        """
    static let primaryAndSecondaryConfiguration = AlertButtons.primaryAndSecondary("Primary", "Secondary")
    static let primaryConfiguration = AlertButtons.primary("Primary")
    static let secondaryConfiguration = AlertButtons.secondary("Secondary")

    static var previews: some View {
        PreviewWrapper {
            standalone

            Group {
                basic
                basicNoIcon
                suppressed
                suppressedNoIcon
            }

            Group {
                inlineBasic
                inlineNoIcon
                inlineSuppressed
                inlineSuppressedNoIcon
            }

            primaryButtonOnly
            noButtons
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(alignment: .leading, spacing: .large) {
            Alert(
                "Alert with\n<u>multiline</u> title",
                description: "Alert <strong>multiline</strong> description\nwith <applink1>link</applink1>",
                icon: .grid,
                buttons: primaryAndSecondaryConfiguration
            ) {
                contentPlaceholder
                    .frame(height: 30)
                    .clipped()
            }

            Group {
                Alert("Alert title", buttons: .primary("Primary"), status: .info)
                Alert(description: "Alert description", buttons: .primary("Primary"), status: .info)
                Alert("Alert title", status: .info)
                Alert(description: "Alert description", status: .info)
            }

            Alert("Inline alert", icon: .grid, button: "Primary", status: .warning, isSuppressed: false)
            Alert("Inline alert", button: "Primary", status: .warning, isSuppressed: false)

            Alert("Inline alert with no button", icon: .informationCircle, status: .success)
            Alert("Inline alert with no button", status: .success)
                .fixedSize()
            Alert(button: .init(stringLiteral: "Primary"), status: .critical)
                .fixedSize()

            Alert("Inline alert with very very very very very very very very very very very long and <u>multiline</u> title", icon: .grid, button: "Primary", status: .warning, isSuppressed: false)
        }
        .previewDisplayName()
    }

    static var basic: some View {
        alerts(showIcons: true, isSuppressed: false)
            .previewDisplayName()
    }

    static var basicNoIcon: some View {
        alerts(showIcons: false, isSuppressed: false)
            .previewDisplayName()
    }

    static var suppressed: some View {
        alerts(showIcons: true, isSuppressed: true)
            .previewDisplayName()
    }

    static var suppressedNoIcon: some View {
        alerts(showIcons: false, isSuppressed: true)
            .previewDisplayName()
    }

    static var inlineBasic: some View {
        inlineAlerts(showIcon: true, isSuppressed: false)
            .previewDisplayName()
    }

    static var inlineNoIcon: some View {
        inlineAlerts(showIcon: false, isSuppressed: false)
            .previewDisplayName()
    }

    static var inlineSuppressed: some View {
        inlineAlerts(showIcon: true, isSuppressed: true)
            .previewDisplayName()
    }

    static var inlineSuppressedNoIcon: some View {
        inlineAlerts(showIcon: false, isSuppressed: true)
            .previewDisplayName()
    }

    static func alert(_ title: String, status: Status, icon: Icon.Symbol, isSuppressed: Bool) -> some View {
        Alert(
            title,
            description: description,
            icon: .symbol(icon),
            buttons: primaryAndSecondaryConfiguration,
            status: status,
            isSuppressed: isSuppressed
        )
    }

    static func alerts(showIcons: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            alert("Informational message", status: .info, icon: showIcons ? .informationCircle : .none, isSuppressed: isSuppressed)
            alert("Success message", status: .success, icon: showIcons ? .checkCircle : .none, isSuppressed: isSuppressed)
            alert("Warning message", status: .warning, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
            alert("Critical message", status: .critical, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
        }
    }

    static func inlineAlerts(showIcon: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            Alert("Informational message", icon: showIcon ? .informationCircle : .none, button: "Primary", status: .info, isSuppressed: isSuppressed)
            Alert("Success message", icon: showIcon ? .checkCircle : .none, button: "Primary", status: .success, isSuppressed: isSuppressed)
            Alert("Warning message", icon: showIcon ? .alertCircle : .none, button: "Primary", status: .warning, isSuppressed: isSuppressed)
            Alert("Critical message", icon: showIcon ? .alertCircle : .none, button: "Primary", status: .critical, isSuppressed: isSuppressed)
        }
    }

    static var primaryButtonOnly: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(description: description, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(title, description: description, buttons: Self.primaryConfiguration)
            Alert(description: description, buttons: Self.primaryConfiguration)
            Alert( title, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(title, buttons: Self.primaryConfiguration)
            Alert(icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(buttons: Self.primaryConfiguration)
            Alert("Intrinsic width", buttons: Self.primaryConfiguration)
                .fixedSize(horizontal: true, vertical: false)
        }
        .previewDisplayName()
    }
    
    static var noButtons: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle)
            Alert(title, description: description)
            Alert(title) {
                contentPlaceholder
            }
            Alert {
                contentPlaceholder
            }
            Alert(title, icon: .informationCircle)
            Alert(icon: .informationCircle)
            Alert(title)
            Alert()
            Alert("Intrinsic width")
                .fixedSize(horizontal: true, vertical: false)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
            .padding(.medium)
    }
}

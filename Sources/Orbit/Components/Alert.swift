import SwiftUI

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
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Alert<Content: View>: View {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.status) private var status

    let title: String
    let description: String
    let icon: Icon.Content?
    let buttons: AlertButtons
    let style: AlertStyle
    @ViewBuilder let content: Content

    private let variant: AlertVariant

    public var body: some View {
        variantContent
            .background(background)
            .cornerRadius(BorderRadius.default)
            .accessibilityElement(children: .contain)
    }

    @ViewBuilder var variantContent: some View {
        switch variant {
            case .default:  defaultContent
            case .inline:   inlineContent
        }
    }

    @ViewBuilder var defaultContent: some View {
        HStack(alignment: .top, spacing: .xSmall) {
            iconContent
                .padding(.leading, -.xxSmall)

            VStack(alignment: .leading, spacing: .medium) {
                defaultHeader
                content
                defaultButtons
            }
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .padding(.medium)
    }

    @ViewBuilder var inlineContent: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            inlineHeader

            if idealSize.horizontal != true {
                Spacer(minLength: 0)
            }

            inlineButton
        }
    }

    @ViewBuilder var defaultHeader: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(alignment: .leading, spacing: .xxSmall) {
                titleContent
                Text(description)
                    .textLinkColor(.secondary)
                    .accessibility(.alertDescription)
            }
        }
    }

    @ViewBuilder var inlineHeader: some View {
        if isInlineHeaderEmpty == false {
            HStack(alignment: .top, spacing: .xSmall) {
                iconContent
                titleContent
            }
            .padding(.vertical, 14)
            .padding(.horizontal, .small)
            .padding(.top, 3)
        }
    }

    @ViewBuilder var iconContent: some View {
        Icon(content: icon)
            .foregroundColor(foregroundColor)
            .accessibility(.alertIcon)
    }

    @ViewBuilder var titleContent: some View {
        Text(title)
            .bold()
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
                foregroundColor
                    .frame(height: 3),
                alignment: .top
            )
    }

    var foregroundColor: Color {
        switch style {
            case .status(let status, _):        return (status ?? defaultStatus).color
        }
    }
    
    var backgroundColor: Color {
        switch style {
            case .status(_, true):              return .cloudLight
            case .status(let status, false):    return (status ?? defaultStatus).lightColor
        }
    }

    var strokeColor: Color {
        switch style {
            case .status(_, true):              return .cloudLightHover
            case .status(let status, false):    return (status ?? defaultStatus).lightHoverColor
        }
    }

    var primaryButtonStyle: Orbit.Button.Style {
        switch style {
            case .status(let status, _):
                return .status(status ?? defaultStatus, isSubtle: false)
        }
    }

    var secondaryButtonStyle: Orbit.Button.Style {
        switch style {
            case .status(_, true):
                return .secondary
            case .status(let status, false):
                return .status(status ?? defaultStatus, isSubtle: true)
        }
    }

    var defaultStatus: Status {
        status ?? .info
    }

    var isInlineHeaderEmpty: Bool {
        isIconEmpty && title.isEmpty
    }

    private var isIconEmpty: Bool {
        icon?.isEmpty ?? true
    }
}

// MARK: - Inits
public extension Alert {
    
    /// Creates Orbit Alert component.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content? = nil,
        buttons: AlertButtons = .none,
        style: AlertStyle = .status(nil, isSubtle: false),
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.buttons = buttons
        self.style = style
        self.variant = .default
        self.content = content()
    }

    /// Creates Orbit Alert (inline) component.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ title: String = "",
        icon: Icon.Content? = nil,
        button: Button.Content? = nil,
        style: AlertStyle = .status(nil, isSubtle: false)
    ) where Content == EmptyView {
        self.title = title
        self.description = ""
        self.icon = icon
        self.buttons = button.map { .primary($0) } ?? .none
        self.style = style
        self.variant = .inline
        self.content = EmptyView()
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

// MARK: - Types

enum AlertVariant {
    case `default`
    case inline
}

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

/// A style of Orbit Alert component.
public enum AlertStyle {

    /// A style related to a `status`. Can be optionally modified using `status()` modifier when `nil` value is provided.
    case status(Status? = nil, isSubtle: Bool = false)

    public static var info: Self {
        .status(.info)
    }

    public static var success: Self {
        .status(.success)
    }

    public static var warning: Self {
        .status(.warning)
    }

    public static var critical: Self {
        .status(.critical)
    }
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
            mixed

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
        Alert(
            title,
            description: description,
            icon: .informationCircle,
            buttons: primaryAndSecondaryConfiguration,
            style: .status(.info, isSubtle: false)
        ) {
            contentPlaceholder
        }
        .previewDisplayName()
    }

    static var mixed: some View {
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
                Alert("Alert title", buttons: .primary("Primary"))
                Alert(description: "Alert description", buttons: .primary("Primary"))
                Alert("Alert title")
                Alert(description: "Alert description")
            }

            Group {
                Alert("Inline alert", icon: .grid, button: "Primary")
                Alert("Inline alert", button: "Primary")
            }
            .status(.warning)

            Group {
                Alert("Inline alert with no button", icon: .informationCircle)
                Alert("Inline alert with no button")
                    .idealSize()
            }
            .status(.success)

            Alert(button: .init(stringLiteral: "Primary"))
                .idealSize()
                .status(.critical)

            Alert("Inline alert with very very very very very very very very very very very long and <u>multiline</u> title", icon: .grid, button: "Primary")
                .status(.warning)
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

    static func alert(_ title: String, status: Status, icon: Icon.Symbol?, isSuppressed: Bool) -> some View {
        Alert(
            title,
            description: description,
            icon: icon.map { Icon.Content.symbol($0) },
            buttons: primaryAndSecondaryConfiguration,
            style: .status(nil, isSubtle: isSuppressed)
        )
        .status(status)
    }

    static func alerts(showIcons: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            alert("Informational message", status: .info, icon: showIcons ? .informationCircle : nil, isSuppressed: isSuppressed)
            alert("Success message", status: .success, icon: showIcons ? .checkCircle : .none, isSuppressed: isSuppressed)
            alert("Warning message", status: .warning, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
            alert("Critical message", status: .critical, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
        }
    }

    static func inlineAlerts(showIcon: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            Alert("Informational message", icon: showIcon ? .informationCircle : .none, button: "Primary", style: .status(nil, isSubtle: isSuppressed))
            Alert("Success message", icon: showIcon ? .checkCircle : .none, button: "Primary", style: .status(.success, isSubtle: isSuppressed))
            Alert("Warning message", icon: showIcon ? .alertCircle : .none, button: "Primary", style: .status(.warning, isSubtle: isSuppressed))
            Alert("Critical message", icon: showIcon ? .alertCircle : .none, button: "Primary", style: .status(.critical, isSubtle: isSuppressed))
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
                .idealSize(horizontal: true, vertical: false)
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
                .idealSize(horizontal: true, vertical: false)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        mixed
            .padding(.medium)
    }
}

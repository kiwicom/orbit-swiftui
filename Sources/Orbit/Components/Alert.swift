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
public struct Alert<Content: View, Icon: View>: View {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.idealSize) private var idealSize
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor
    @Environment(\.textLinkColor) private var textLinkColor

    let title: String
    let description: String
    let buttons: AlertButtons?
    let style: AlertStyle
    @ViewBuilder let content: Content
    @ViewBuilder let icon: Icon

    public var body: some View {
        variantContent
            .background(background)
            .cornerRadius(BorderRadius.default)
            .accessibilityElement(children: .contain)
    }

    @ViewBuilder var variantContent: some View {
        switch buttons {
            case .inline(let button):   inlineContent(button)
            default:                    defaultContent
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

    @ViewBuilder func inlineContent(_ button: ButtonContent?) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            inlineHeader

            if idealSize.horizontal != true {
                Spacer(minLength: 0)
            }

            if let button {
                Button(button.label, type: primaryButtonType, action: button.action)
                    .buttonSize(.compact)
                    .idealSize()
                    .padding(.xSmall)
                    .padding(.top, 3)
                    .accessibility(.alertButtonPrimary)
            }
        }
    }

    @ViewBuilder var defaultHeader: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(alignment: .leading, spacing: .xxSmall) {
                titleContent
                Text(description)
                    .textLinkColor(textLinkColor ?? textColor.map { TextLink.Color.custom($0) } ?? .secondary)
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
        icon
            .font(.system(size: Orbit.Icon.Size.normal.value))
            .foregroundColor(iconColor ?? outlineColor)
            .iconColor(iconColor ?? outlineColor)
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
                            Button(primaryButton.label, type: primaryButtonType, action: primaryButton.action)
                                .accessibility(.alertButtonPrimary)
                        case .none, .secondary, .inline:
                            EmptyView()
                    }

                    switch buttons {
                        case .secondary(let secondaryButton),
                             .primaryAndSecondary(_, let secondaryButton):
                            Button(secondaryButton.label, type: secondaryButtonType, action: secondaryButton.action)
                                .accessibility(.alertButtonSecondary)
                        case .none, .primary, .inline:
                            EmptyView()
                    }
                }
                .buttonSize(.compact)
            case .none, .inline:
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
                outlineColor
                    .frame(height: 3),
                alignment: .top
            )
    }

    var outlineColor: Color {
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

    var primaryButtonType: ButtonType {
        switch style {
            case .status(let status, _):
                return .status(status ?? defaultStatus, isSubtle: false)
        }
    }

    var secondaryButtonType: ButtonType {
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
        icon.isEmpty && title.isEmpty
    }
}

// MARK: - Inits
public extension Alert {

    /// Creates Orbit Alert component with custom content and icon.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ title: String = "",
        description: String = "",
        buttons: AlertButtons? = nil,
        style: AlertStyle = .status(nil, isSubtle: false),
        @ViewBuilder content: () -> Content,
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.icon = icon()
        self.buttons = buttons
        self.style = style
        self.content = content()
    }

    /// Creates Orbit Alert component.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        buttons: AlertButtons? = nil,
        style: AlertStyle = .status(nil, isSubtle: false)
    ) where Icon == Orbit.Icon, Content == EmptyView {
        self.init(
            title: title,
            description: description,
            buttons: buttons,
            style: style
        ) {
            EmptyView()
        } icon: {
            Icon(icon)
        }
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
    case primary(ButtonContent)
    case secondary(ButtonContent)
    case primaryAndSecondary(ButtonContent, ButtonContent)
    case inline(ButtonContent)
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
            buttons: primaryAndSecondaryConfiguration,
            style: .status(.info, isSubtle: false)
        ) {
            contentPlaceholder
        } icon: {
            Icon(.informationCircle)
        }
        .previewDisplayName()
    }

    static var mixed: some View {
        VStack(alignment: .leading, spacing: .large) {
            Alert(
                "Alert with\n<u>multiline</u> title",
                description: "Alert <strong>multiline</strong> description\nwith <applink1>link</applink1>",
                buttons: primaryAndSecondaryConfiguration
            ) {
                contentPlaceholder
                    .frame(height: 30)
                    .clipped()
            } icon: {
                Icon(.grid)
            }

            Group {
                Alert("Alert title", buttons: .primary("Primary"))
                Alert(description: "Alert description", buttons: .primary("Primary"))
                Alert("Alert title")
                Alert(description: "Alert description")
            }

            Group {
                Alert("Inline alert", icon: .grid, buttons: .inline("Primary"))
                Alert("Inline alert", buttons: .inline("Primary"))
            }
            .status(.warning)

            Group {
                Alert("Alert with no button", icon: .informationCircle)
                Alert("Alert with no button")
                    .idealSize()
            }
            .status(.success)

            Alert(buttons: .inline("Primary"))
                .idealSize()
                .status(.critical)

            Alert("Inline alert with very very very very very very very very very very very long and <u>multiline</u> title", icon: .grid, buttons: .inline("Primary"))
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
            icon: icon,
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
            Alert("Informational message", icon: showIcon ? .informationCircle : .none, buttons: .inline("Primary"), style: .status(nil, isSubtle: isSuppressed))
            Alert("Success message", icon: showIcon ? .checkCircle : .none, buttons: .inline("Primary"), style: .status(.success, isSubtle: isSuppressed))
            Alert("Warning message", icon: showIcon ? .alertCircle : .none, buttons: .inline("Primary"), style: .status(.warning, isSubtle: isSuppressed))
            Alert("Critical message", icon: showIcon ? .alertCircle : .none, buttons: .inline("Primary"), style: .status(.critical, isSubtle: isSuppressed))
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

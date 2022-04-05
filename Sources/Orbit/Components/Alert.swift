import SwiftUI

public enum AlertButtons {
    case none
    case primary(Button.Content)
    case secondary(Button.Content)
    case primaryAndSecondary(Button.Content, Button.Content)
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
/// - Related components:
///   - ``Heading`` + ``Text``
///   - ``Toast``
///   - ``EmptyState``
///   - ``Modal``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/alert/)
/// - Important: Component expands horizontally to infinity.
public struct Alert<Content: View>: View {

    let title: String
    let description: String
    let icon: Icon.Symbol
    let buttons: AlertButtons
    let status: Status
    let isSuppressed: Bool
    let descriptionLinkAction: TextLink.Action
    let content: () -> Content

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            
            Icon(icon, size: .normal, color: status.color)
            
            VStack(alignment: .leading, spacing: .medium) {
                
                VStack(alignment: .leading, spacing: .xxSmall) {
                    Text(title, weight: .bold)
                    Text(description, linkColor: .inkNormal, linkAction: descriptionLinkAction)
                }
                
                content()
                
                switch buttons {
                    case .primary, .secondary, .primaryAndSecondary:
                        // Keeping the identity of buttons for correct animations
                        buttonsView
                    case .none:
                        EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.vertical, .trailing], .medium)
        .padding(.leading, icon == .none ? .medium : .small)
        .background(background)
        .cornerRadius(BorderRadius.default)
    }

    @ViewBuilder var buttonsView: some View {
        HStack(spacing: .small) {
            switch buttons {
                case .primary(let primaryButton),
                     .primaryAndSecondary(let primaryButton, _):
                    Button(primaryButton.label, style: primaryButtonStyle, size: .small, action: primaryButton.action)
                case .none, .secondary:
                    EmptyView()
            }

            switch buttons {
                case .secondary(let secondaryButton),
                     .primaryAndSecondary(_, let secondaryButton):
                    Button(secondaryButton.label, style: secondaryButtonStyle, size: .small, action: secondaryButton.action)
                case .none, .primary:
                    EmptyView()
            }
        }
    }

    @ViewBuilder var background: some View {
        backgroundColor
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .strokeBorder(strokeColor)
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
}

// MARK: - Inits
public extension Alert {
    
    /// Creates Orbit Alert component including custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        buttons: AlertButtons = .none,
        status: Status = .info,
        isSuppressed: Bool = false,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.buttons = buttons
        self.status = status
        self.isSuppressed = isSuppressed
        self.descriptionLinkAction = descriptionLinkAction
        self.content = content
    }
    
    /// Creates Orbit Alert component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
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
}

// MARK: - Previews
struct AlertPreviews: PreviewProvider {

    private static let primaryAndSecondaryConfiguration = AlertButtons.primaryAndSecondary("Primary", "Secondary")
    private static let primaryConfiguration = AlertButtons.primary("Primary")
    private static let secondaryConfiguration = AlertButtons.secondary("Secondary")

    static var previews: some View {
        PreviewWrapperWithState(initialState: Self.primaryAndSecondaryConfiguration) { buttonConfiguration in
            standalone
            snapshotSuppressed
            snapshots
            snapshotsNoButtons

            VStack {
                Alert(
                    "Your message - make it short & clear",
                    description: "Description - make it as clear as possible. Now double the length.",
                    icon: .informationCircle,
                    buttons: buttonConfiguration.wrappedValue
                )

                Spacer()

                Button("Live Preview") {
                    withAnimation(.spring()) {
                        switch buttonConfiguration.wrappedValue {
                            case .none:
                                buttonConfiguration.wrappedValue = Self.primaryConfiguration
                            case .primary:
                                buttonConfiguration.wrappedValue = Self.secondaryConfiguration
                            case .secondary:
                                buttonConfiguration.wrappedValue = Self.primaryAndSecondaryConfiguration
                            case .primaryAndSecondary:
                                buttonConfiguration.wrappedValue = .none
                        }
                    }
                }
            }
            .padding()
            .previewDisplayName("Live Preview")
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Alert(
            "Title",
            description: #"Alert description with <u>underline</u> vs <a href="..">link</a>."#,
            icon: .informationCircle,
            buttons: Self.primaryAndSecondaryConfiguration
        ) {
            customContentPlaceholder
        }
        .padding()
    }

    static var orbit: some View {
        VStack(spacing: .medium) {
            Alert(
                "Your message - make it short & clear",
                description: "Description - make it as clear as possible. Now double the length.",
                icon: .informationCircle,
                buttons: Self.primaryAndSecondaryConfiguration
            )
            Alert(
                "Your message - make it short & clear",
                description: """
                Description - Make it as clear as possible. Now three times as long as before, because \
                we need to test multiline variants properly as well.
                """,
                icon: .informationCircle,
                buttons: Self.primaryAndSecondaryConfiguration,
                status: .success
            )
            Alert(
                """
                Your message - make it short & clear. If you don't make the title clear enough, it will look \
                like this
                """,
                description: "Description - make it as clear as possible.",
                icon: .informationCircle,
                buttons: Self.primaryAndSecondaryConfiguration,
                status: .warning
            )
            Alert(
                """
                Your message - make it short & clear. If you don't make the title clear enough, it will look \
                like this
                """,
                description: """
                Description - Make it as clear as possible. Now three times as long as before, because we need \
                to test multiline variants properly as well.
                """,
                icon: .informationCircle,
                buttons: Self.primaryAndSecondaryConfiguration,
                status: .critical
            )
        }
    }

    static var snapshots: some View {
        VStack(spacing: .medium) {
            Alert(
                "Your message - make it short & clear",
                description: "Description - make it as clear as possible.",
                icon: .informationCircle,
                buttons: Self.primaryAndSecondaryConfiguration
            )
            Alert(
                "Your message - make it short & clear",
                description: "Description - make it as clear as possible.",
                buttons: Self.primaryAndSecondaryConfiguration,
                status: .warning
            )
            Alert(
                "Your message - make it short & clear",
                icon: .informationCircle,
                buttons: Self.primaryAndSecondaryConfiguration,
                status: .critical
            )
            Alert(
                "Your message - make it short & clear",
                buttons: Self.primaryAndSecondaryConfiguration,
                status: .success
            )
            Alert(
                "Your message - make it short & clear",
                description: "Description - make it as clear as possible.",
                icon: .informationCircle,
                buttons: Self.primaryConfiguration
            )
            Alert(
                "Your message - make it short & clear",
                description: "Description - make it as clear as possible.",
                buttons: Self.primaryConfiguration
            )
            Alert(
                "Your message - make it short & clear",
                icon: .informationCircle,
                buttons: Self.primaryConfiguration
            )
            Alert(
                "Your message - make it short & clear",
                buttons: Self.primaryConfiguration
            )
        }
        .padding()
        .previewDisplayName("Layout")
    }
    
    static var snapshotsNoButtons: some View {
        VStack(spacing: .medium) {
            Alert(
                "Your message - make it short & clear",
                description: "Description - make it as clear as possible.",
                icon: .informationCircle
            )
            
            Alert("Title", description: "Description")
            Alert("Title") {
                customContentPlaceholder
            }
            Alert("Title", icon: .informationCircle)
            Alert("Title")
        }
        .padding()
        .previewDisplayName("No buttons")
    }

    static var snapshotsStatuses: some View {
        orbit
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Statuses")
    }
    
    static var snapshotSuppressed: some View {
        Alert(
            "Title",
            description: #"Alert description with <u>underline</u> vs <a href="..">link</a>."#,
            icon: .informationCircle,
            buttons: Self.primaryAndSecondaryConfiguration,
            isSuppressed: true
        ) {
            customContentPlaceholder
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Status Suppressed")
    }
}

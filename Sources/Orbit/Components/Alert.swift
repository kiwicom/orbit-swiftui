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
/// - Related components:
///   - ``Heading`` + ``Text``
///   - ``Toast``
///   - ``EmptyState``
///   - ``Modal``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/alert/)
/// - Important: Component expands horizontally to infinity.
public struct Alert: View {

    let title: String
    let description: String
    let icon: Icon.Symbol
    let buttons: Buttons
    let status: Status
    let isSuppressed: Bool
    let descriptionLinkAction: TextLink.Action

    public var body: some View {
        VStack(alignment: .leading, spacing: .medium) {
            
            Header(
                title,
                description: description,
                iconContent: .icon(icon, size: .default, color: status.color),
                titleStyle: .text(weight: .bold),
                descriptionStyle: .custom(.normal, color: .inkNormal, linkColor: .inkNormal),
                horizontalSpacing: .xSmall,
                verticalSpacing: .xxSmall,
                descriptionLinkAction: descriptionLinkAction
            )
            
            switch buttons {
                case .primary, .secondary, .primaryAndSecondary:
                    // Keeping the identity of buttons for correct animations
                    buttonsView
                case .none:
                    EmptyView()
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
                case .primary(let title, let action),
                     .primaryAndSecondary(let title, _, let action, _):
                    Button(title, style: primaryButtonStyle, size: .small, action: action)
                case .none, .secondary:
                    EmptyView()
            }

            switch buttons {
                case .secondary(let title, let action),
                     .primaryAndSecondary(_, let title, _, let action):
                    Button(title, style: secondaryButtonStyle, size: .small, action: action)
                case .none, .primary:
                    EmptyView()
            }
        }
        .padding(.leading, icon == .none ? 0 : 28)
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
    
    /// Creates Orbit Alert component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        buttons: Buttons = .none,
        status: Status = .info,
        isSuppressed: Bool = false,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.buttons = buttons
        self.status = status
        self.isSuppressed = isSuppressed
        self.descriptionLinkAction = descriptionLinkAction
    }
}

// MARK: - Types
public extension Alert {

    enum Buttons {
        case none
        case primary(_ title: String, action: () -> Void = {})
        case secondary(_ title: String, action: () -> Void = {})
        case primaryAndSecondary(
            primaryTitle: String,
            secondaryTitle: String,
            primaryAction: () -> Void = {},
            secondaryAction: () -> Void = {}
        )
    }
}

// MARK: - Previews
struct AlertPreviews: PreviewProvider {

    private static let primaryAndSecondaryConfiguration = Alert.Buttons.primaryAndSecondary(
        primaryTitle: "Primary",
        secondaryTitle: "Secondary"
    )

    private static let primaryConfiguration = Alert.Buttons.primary("Primary")
    private static let secondaryConfiguration = Alert.Buttons.secondary("Secondary")

    static var previews: some View {
        PreviewWrapperWithState(initialState: Self.primaryAndSecondaryConfiguration) { buttonConfiguration in
            standalone
                .previewLayout(.sizeThatFits)

            snapshotSuppressed
            
            snapshots
                .previewLayout(.sizeThatFits)

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
    }

    static var standalone: some View {
        Alert(
            "Title",
            description: #"Alert description with <u>underline</u> vs <a href="..">link</a>."#,
            icon: .informationCircle,
            buttons: .primaryAndSecondary(
                primaryTitle: "Primary",
                secondaryTitle: "Secondary"
            )
        )
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
        Group {
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
            .padding(.vertical)
            .previewDisplayName("Layout")

            VStack(spacing: .medium) {
                Alert(
                    "Your message - make it short & clear",
                    description: "Description - make it as clear as possible.",
                    icon: .informationCircle
                )
                
                Alert("Title", description: "Description")
                Alert("Title", icon: .informationCircle)
                Alert("Title")
            }
            .padding(.vertical)
            .previewDisplayName("No buttons")
        }
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
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
            buttons: .primaryAndSecondary(
                primaryTitle: "Primary",
                secondaryTitle: "Secondary"
            ),
            isSuppressed: true
        )
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Status Suppressed")
    }
}

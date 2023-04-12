import SwiftUI

/// Prompts users to take or complete an action.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/overlay/dialog/)
public struct Dialog<Content: View>: View {

    let illustration: Illustration.Image
    let title: String
    let description: String
    let style: Style
    let buttonConfiguration: Buttons
    @ViewBuilder let content: Content

    public var body: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Illustration(illustration, layout: .resizeable)
                .frame(height: 120)

            VStack(alignment: .leading, spacing: .xSmall) {
                Heading(title, style: .title3)
                    .accessibility(.dialogTitle)

                Text(description)
                    .foregroundColor(.inkNormal)
                    .accessibility(.dialogDescription)
            }

            content

            VStack(spacing: .xSmall) {
                buttons
            }
        }
        .frame(maxWidth: Layout.readableMaxWidth / 2)
        .padding(.medium)
        .background(Color.whiteDarker)
        .clipShape(shape)
        .elevation(.level4, shape: .roundedRectangle(borderRadius: .small))
        .padding(.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.overlay.edgesIgnoringSafeArea(.all))
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder var buttons: some View {
        switch buttonConfiguration {
            case .primary(let primaryButton),
                 .primaryAndSecondary(let primaryButton, _),
                 .primarySecondaryAndTertiary(let primaryButton, _, _):
                Button(primaryButton.label, style: style.buttonStyle, action: primaryButton.action)
                    .accessibility(.dialogButtonPrimary)
        }

        switch buttonConfiguration {
            case .primary:
                EmptyView()
            case .primaryAndSecondary(_, let secondaryButton),
                 .primarySecondaryAndTertiary(_, let secondaryButton, _):
                ButtonLink(secondaryButton.label, style: style.buttonLinkStyle, size: .button, action: secondaryButton.action)
                    .accessibility(.dialogButtonSecondary)
        }

        switch buttonConfiguration {
            case .primary, .primaryAndSecondary:
                EmptyView()
            case .primarySecondaryAndTertiary(_, _, let tertiaryButton):
                ButtonLink(tertiaryButton.label, style: style.buttonLinkStyle, size: .button, action: tertiaryButton.action)
                    .accessibility(.dialogButtonTertiary)
        }
    }

    var shape: some InsettableShape {
        RoundedRectangle(cornerRadius: .small)
    }
}

// MARK: - Inits
extension Dialog {

    /// Creates Orbit Dialog component.
    public init(
        illustration: Illustration.Image = .none,
        title: String = "",
        description: String = "",
        style: Style = .primary,
        buttons: Buttons,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.illustration = illustration
        self.title = title
        self.description = description
        self.style = style
        self.buttonConfiguration = buttons
        self.content = content()
    }
}

// MARK: - Types
extension Dialog {

    public enum Buttons {
        case primary(Button.Content)
        case primaryAndSecondary(Button.Content, Button.Content)
        case primarySecondaryAndTertiary(Button.Content, Button.Content, Button.Content)
    }

    public enum Style {
        case primary
        case critical

        public var buttonStyle: Orbit.Button.Style {
            switch self {
                case .primary:              return .primary
                case .critical:             return .critical
            }
        }

        public var buttonLinkStyle: Orbit.ButtonLink.Style {
            switch self {
                case .primary:              return .primary
                case .critical:             return .critical
            }
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let dialogTitle              = Self(rawValue: "orbit.dialog.title")
    static let dialogDescription        = Self(rawValue: "orbit.dialog.description")
    static let dialogButtonPrimary      = Self(rawValue: "orbit.dialog.button.primary")
    static let dialogButtonSecondary    = Self(rawValue: "orbit.dialog.button.secondary")
    static let dialogButtonTertiary     = Self(rawValue: "orbit.dialog.button.tertiary")
}

// MARK: - Previews
struct DialogPreviews: PreviewProvider {

    static let title1 = "Kiwi.com would like to send you notifications."
    static let title2 = "Do you really want to delete your account?"

    static let description1 = "Notifications may include alerts, sounds, and icon badges."
        + "These can be configured in <applink1>Settings</applink1>"
    static let description2 = "This action is irreversible, once you delete your account, it's gone."
        + " It will not affect any bookings in progress."
    
    static var previews: some View {
        PreviewWrapper {
            content
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        standalone
        critical
        titleOnly
        descriptionOnly
    }

    static var standalone: some View {
        Dialog(
            illustration: .noNotification,
            title: title1,
            description: description1,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        ) {
            contentPlaceholder
        }
        .previewDisplayName()
    }

    static var critical: some View {
        Dialog(
            illustration: .noNotification,
            title: title2,
            description: description2,
            style: .critical,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        )
        .previewDisplayName()
    }

    static var titleOnly: some View {
        Dialog(
            title: title1,
            buttons: .primaryAndSecondary("Main CTA", "Secondary")
        )
        .previewDisplayName()
    }

    static var descriptionOnly: some View {
        Dialog(
            description: description1,
            buttons: .primary("Main CTA")
        )
        .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
            .background(Color.whiteNormal)
    }
}

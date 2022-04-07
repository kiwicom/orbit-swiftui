import SwiftUI

/// Prompts users to take or complete an action.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/overlay/dialog/)
public struct Dialog: View {

    public static let shadowColor = Color.inkNormal

    let illustration: Illustration.Image
    let title: String
    let description: String
    let style: Style
    let buttonConfiguration: Buttons

    public var body: some View {
        VStack(alignment: .center, spacing: .medium) {
            Illustration(illustration, layout: .frame(maxHeight: 120))
                .padding(.top, .medium)

            VStack(alignment: .center, spacing: .xSmall) {
                Heading(title, style: .title3, alignment: .center)
                Text(description, color: .inkLight, alignment: .center)
            }

            VStack(alignment: .center, spacing: .xSmall) {
                buttons
            }
        }
        .padding(.medium)
        .background(
            RoundedRectangle(cornerRadius: .small)
                .fill(.white)
                .shadow(color: Self.shadowColor.opacity(0.7), radius: .xxxLarge, x: 0, y: .xxxLarge / 2)
        )
        .frame(maxWidth: Layout.readableMaxWidth / 2, maxHeight: .infinity)
        .padding(.xLarge)
        .background(Color.inkNormal.opacity(0.45))
        .edgesIgnoringSafeArea(.all)
    }

    @ViewBuilder var buttons: some View {
        switch buttonConfiguration {
            case .primary(let primaryButton),
                 .primaryAndSecondary(let primaryButton, _),
                 .primarySecondaryAndTertiary(let primaryButton, _, _):
                Button(primaryButton.label, style: style.buttonStyle, action: primaryButton.action)
                    .accessibility(identifier: primaryButton.accessibilityIdentifier)
        }

        switch buttonConfiguration {
            case .primary:
                EmptyView()
            case .primaryAndSecondary(_, let secondaryButton),
                 .primarySecondaryAndTertiary(_, let secondaryButton, _):
                ButtonLink(secondaryButton.label, style: style.buttonLinkStyle, size: .button, action: secondaryButton.action)
                    .accessibility(identifier: secondaryButton.accessibilityIdentifier)
        }

        switch buttonConfiguration {
            case .primary:
                EmptyView()
            case .primaryAndSecondary:
                EmptyView()
            case .primarySecondaryAndTertiary(_, _, let tertiaryButton):
                ButtonLink(tertiaryButton.label, style: style.buttonLinkStyle, size: .button, action: tertiaryButton.action)
                    .accessibility(identifier: tertiaryButton.accessibilityIdentifier)
        }
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
        buttons: Buttons
    ) {
        self.illustration = illustration
        self.title = title
        self.description = description
        self.style = style
        self.buttonConfiguration = buttons
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

// MARK: - Previews
struct DialogPreviews: PreviewProvider {

    static let title1 = "Kiwi.com would like to send you notifications."
    static let title2 = "Do you really want to delete your account?"

    static let description1 = "Notifications may include alerts, sounds, and icon badges."
        + "These can be configured in Settings"
    static let description2 = "This action is irreversible, once you delete your account, it's gone."
        + " It will not affect any bookings in progress."
    
    static var previews: some View {
        PreviewWrapper {
            normal
            critical
            titleOnly
            descriptionOnly
        }
        .previewLayout(.sizeThatFits)
    }

    static var normal: some View {
        Dialog(
            illustration: .noNotification,
            title: title1,
            description: description1,
            buttons: .primarySecondaryAndTertiary("Allow", "Ask later", "Cancel")
        )
        .background(Color.white)
    }

    static var critical: some View {
        Dialog(
            illustration: .noNotification,
            title: title2,
            description: description2,
            style: .critical,
            buttons: .primarySecondaryAndTertiary("Delete", "Ask later", "Cancel")
        )
        .background(Color.white)
    }

    static var titleOnly: some View {
        Dialog(
            title: title1,
            buttons: .primaryAndSecondary("Allow", "Deny")
        )
        .background(Color.white)
    }

    static var descriptionOnly: some View {
        Dialog(
            description: description1,
            buttons: .primary("Allow")
        )
        .background(Color.white)
    }
}

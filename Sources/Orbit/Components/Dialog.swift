import SwiftUI

/// Prompts users to take or complete an action.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/overlay/dialog/)
public struct Dialog: View {

    let illustration: Illustration.Image
    let title: String
    let description: String
    let style: Style
    let alignment: HorizontalAlignment
    let buttonConfiguration: Buttons

    public var body: some View {
        VStack(alignment: alignment, spacing: .medium) {
            Illustration(illustration, layout: .resizeable)
                .frame(height: 120)

            VStack(alignment: alignment, spacing: .xSmall) {
                Heading(title, style: .title3, alignment: .init(alignment))
                    .accessibility(.dialogTitle)

                Text(description, color: .inkNormal, alignment: .init(alignment))
                    .accessibility(.dialogDescription)
            }

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
        .background(Color.inkDark.opacity(0.45).edgesIgnoringSafeArea(.all))
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
            case .primary:
                EmptyView()
            case .primaryAndSecondary:
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
        alignment: HorizontalAlignment = .leading,
        buttons: Buttons
    ) {
        self.illustration = illustration
        self.title = title
        self.description = description
        self.style = style
        self.alignment = alignment
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
        + "These can be configured in Settings"
    static let description2 = "This action is irreversible, once you delete your account, it's gone."
        + " It will not affect any bookings in progress."
    
    static var previews: some View {
        PreviewWrapper {
            content
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        normal
        centered
        critical
        titleOnly
        descriptionOnly
    }

    static var storybook: some View {
        VStack(spacing: 0) {
            content
        }
    }

    static var normal: some View {
        Dialog(
            illustration: .noNotification,
            title: title1,
            description: description1,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        )
    }

    static var centered: some View {
        Dialog(
            illustration: .noNotification,
            title: title1,
            description: description1,
            alignment: .center,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        )
        .background(Color.whiteNormal)
    }

    static var critical: some View {
        Dialog(
            illustration: .noNotification,
            title: title2,
            description: description2,
            style: .critical,
            buttons: .primarySecondaryAndTertiary("Main CTA", "Secondary", "Tertiary")
        )
    }

    static var titleOnly: some View {
        Dialog(
            title: title1,
            buttons: .primaryAndSecondary("Main CTA", "Secondary")
        )
    }

    static var descriptionOnly: some View {
        Dialog(
            description: description1,
            buttons: .primary("Main CTA")
        )
    }

    static var snapshot: some View {
        normal
            .background(Color.whiteNormal)
    }
}

struct DialogDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        DialogPreviews.normal
    }
}

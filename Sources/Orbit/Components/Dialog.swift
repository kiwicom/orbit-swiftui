import SwiftUI

/// Prompts users to take or complete an action.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/overlay/dialog/)
public struct Dialog: View {

    public static let shadowColor = Color.inkNormal
    
    let illustration: Illustration.Image
    let title: String
    let description: String
    let buttons: ButtonConfiguration

    public var body: some View {
        VStack(alignment: .center, spacing: .medium) {
            if illustration != .none {
                Illustration(illustration, layout: .frame(maxHeight: 120))
                    .padding(.top, .medium)
            }

            VStack(alignment: .center, spacing: .xSmall) {
                Heading(title, style: .title4, alignment: .center)

                Text(description, color: .inkLight, alignment: .center)
            }

            VStack(alignment: .center, spacing: .xSmall) {
                switch buttons {
                    case .primary(let title, let style, let action):
                        Button(title, style: style.primaryStyle, action: action)
                    case .primaryAndSecondary(
                        let primaryTitle, let secondaryTitle, let style, let primaryAction, let secondaryAction
                    ):
                        Button(primaryTitle, style: style.primaryStyle, action: primaryAction)
                        Button(secondaryTitle, style: style.secondaryStyle, action: secondaryAction)
                }
            }
        }
        .padding(.medium)
        .background(
            RoundedRectangle(cornerRadius: .small)
                .fill(.white)
                .shadow(color: Self.shadowColor.opacity(0.3), radius: .medium, x: 0, y: .medium / 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: .small)
                .strokeBorder(Self.shadowColor.opacity(0.15), lineWidth: BorderWidth.thin)
        )
    }
    
    public init(
        illustration: Illustration.Image = .none,
        title: String = "",
        description: String = "",
        buttons: ButtonConfiguration
    ) {
        self.illustration = illustration
        self.title = title
        self.description = description
        self.buttons = buttons
    }
}

// MARK: - Types
public extension Dialog {
    
    enum ButtonConfiguration {
        case primary(_ title: String, style: ButtonStyle = .normal, action: () -> Void = {})
        case primaryAndSecondary(
            primaryTitle: String,
            secondaryTitle: String,
            style: ButtonStyle = .normal,
            primaryAction: () -> Void = {},
            secondaryAction: () -> Void = {}
        )
    }
    
    enum ButtonStyle {
        case normal
        case critical
        
        var primaryStyle: Button.Style {
            switch self {
                case .normal:               return .primary
                case .critical:             return .critical
            }
        }
        
        var secondaryStyle: Button.Style {
            switch self {
                case .normal:               return .secondary
                case .critical:             return .criticalSubtle
            }
        }
    }
}

// MARK: - Previews
struct DialogPreviews: PreviewProvider {

    static let backgroundColor = Color.inkLighter
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            orbit
            snapshots
        }
    }
    
    static var standalone: some View {
        Dialog(
            illustration: image1,
            title: title1,
            description: description1,
            buttons: buttons1
        )
        .padding(.xLarge)
        .background(backgroundColor)
        .previewLayout(.sizeThatFits)
    }
    
    static var snapshots: some View {
        VStack(spacing: 0) {
            Dialog(
                illustration: image1,
                title: title1,
                description: description1,
                buttons: buttons2
            )
            .padding(.xLarge)
            .background(backgroundColor)
            
            Dialog(
                illustration: image2,
                title: title2,
                description: description2,
                buttons: buttons4
            )
            .padding(.xLarge)
            .background(Color.cloudDarker)
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Snapshots")
    }
    
    static var orbit: some View {
        HStack(spacing: .xLarge) {
            Dialog(illustration: image1, title: title1, description: description1, buttons: buttons1)
            Dialog(description: title1, buttons: buttons1)
            Dialog(
                illustration: image1,
                title: title1,
                description: description1,
                buttons: buttons2
            )
            
            Dialog(illustration: image2, title: title2, description: description2, buttons: buttons2)
            Dialog(title: title2, buttons: buttons4)
            Dialog(
                illustration: image2,
                title: title2,
                description: description2,
                buttons: buttons4
            )
        }
        .padding(.xLarge)
        .background(Color.cloudDarker)
        .previewLayout(.fixed(width: 1900, height: 500))
        .previewDisplayName("Orbit")
    }
}

extension DialogPreviews {
    static var title1: String { "Kiwi.com would like to send you notifications." }
    static var title2: String { "Do you really want to delete your account?" }

    static var description1: String {
        "Notifications may include alerts, sounds, and icon badges. These can be configured in Settings"
    }
    static var description2: String {
        "This action is irreversible, once you delete your account, it's gone."
        + " It will not affect any bookings in progress."
    }
    
    static var image1: Illustration.Image { .noNotification }
    static var image2: Illustration.Image { .error }
    
    static var buttons1: Dialog.ButtonConfiguration { .primary("Allow", style: .normal) }
    static var buttons2: Dialog.ButtonConfiguration {
        .primaryAndSecondary(primaryTitle: "Allow", secondaryTitle: "Cancel")
    }
    static var buttons3: Dialog.ButtonConfiguration { .primary("Allow", style: .critical) }
    static var buttons4: Dialog.ButtonConfiguration {
        .primaryAndSecondary(primaryTitle: "Delete", secondaryTitle: "Cancel", style: .critical)
    }
}

import SwiftUI

/// Lets users sign in using a social service.
///
/// Social buttons are designed to ease the flow for users signing in.
/// Don’t use them in any other case or in any complex scenarios.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/socialbutton/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct SocialButton: View {

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.idealSize) var idealSize

    let label: String
    let service: Service
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                HStack(spacing: .xSmall) {
                    service.logo
                        .scaledToFit()
                        .frame(width: .large * sizeCategory.ratio)

                    Text(label, size: .normal, color: nil, weight: .medium)
                        .padding(.vertical, Button.Size.default.verticalPadding)

                    if idealSize.horizontal == nil {
                        Spacer(minLength: 0)
                    }

                    Icon(.chevronRight, size: .large, color: nil)
                }
                .foregroundColor(labelColor)
            }
        )
        .buttonStyle(OrbitStyle(backgroundColor: backgroundColor, idealSize: idealSize))
    }

    var labelColor: Color {
        switch service {
            case .apple:        return colorScheme == .light ? .white : .black
            case .google:       return .inkDark
            case .facebook:     return .inkDark
            case .email:        return .inkDark
        }
    }

    var backgroundColor: OrbitStyle.BackgroundColor {
        switch service {
            case .apple:        return (
                colorScheme == .light ? .black : .white,
                colorScheme == .light ? .inkNormalActive : .inkNormalActive
            )
            case .google:       return (.cloudNormal, .cloudNormalActive)
            case .facebook:     return (.cloudNormal, .cloudNormalActive)
            case .email:        return (.cloudNormal, .cloudNormalActive)
        }
    }
}

// MARK: - Inits
public extension SocialButton {
    
    /// Creates Orbit SocialButton component.
    init(_ label: String, service: Service, action: @escaping () -> Void = {}) {
        self.label = label
        self.service = service
        self.action = action
    }
}

// MARK: - Types
extension SocialButton {

    private static var appleLogoImage: Image {
        if #available(iOS 14.0, *) {
            return Image(systemName: "applelogo")
        } else {
            return Image.orbit(.apple)
        }
    }

    private static let appleLogo = appleLogoImage
    private static let googleLogo = Image.orbit(.google).resizable()
    private static let facebookLogo = Image.orbit(.facebook).resizable()

    public enum Service {

        case apple
        case google
        case facebook
        case email

        @ViewBuilder var logo: some View {
            switch self {
                case .apple:
                    if #available(iOS 14.0, *) {
                        SocialButton.appleLogo
                            .font(.body)
                            .padding(.horizontal, .xxxSmall)
                            .padding(.bottom, .xxSmall)
                    } else {
                        SocialButton.appleLogo
                    }
                case .google:                               SocialButton.googleLogo
                case .facebook:                             SocialButton.facebookLogo
                case .email:                                Icon(.email, size: .large)
            }
        }
    }

    struct OrbitStyle: ButtonStyle {

        typealias BackgroundColor = (normal: Color, active: Color)

        let backgroundColor: BackgroundColor
        let idealSize: IdealSizeValue

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
                .padding(.horizontal, .small)
                .background(
                    configuration.isPressed ? backgroundColor.active : backgroundColor.normal
                )
                .cornerRadius(BorderRadius.default)
        }
    }
}

// MARK: - Previews
struct SocialButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            intrinsic
            storybook
            storybook
                .preferredColorScheme(.dark)
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        SocialButton("Sign in with Facebook", service: .facebook)
    }

    static var intrinsic: some View {
        storybook
            .idealSize()
            .previewDisplayName("Intrinsic")
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            SocialButton("Sign in with E-mail", service: .email)
            SocialButton("Sign in with Facebook", service: .facebook)
            SocialButton("Sign in with Google", service: .google)
            SocialButton("Sign in with Apple", service: .apple)
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }
}

struct SocialButtonDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        SocialButtonPreviews.storybook
    }
}

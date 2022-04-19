import SwiftUI

/// Lets users sign in using a social service.
///
/// Social buttons are designed to ease the flow for users signing in.
/// Don’t use them in any other case or in any complex scenarios.

/// - Related components:
///   - ``Button``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/socialbutton/)
/// - Important: Component expands horizontally to infinity.
public struct SocialButton: View {

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
                        .frame(width: .large)

                    Text(label, size: .normal, color: nil, weight: .medium)

                    Spacer(minLength: 0)

                    Icon(.chevronRight, size: .large, color: nil)
                }
            }
        )
        .buttonStyle(OrbitStyle(service: service))
        .fixedSize(horizontal: false, vertical: true)
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
    private static let googleLogo = Image.orbit(.google)
    private static let facebookLogo = Image.orbit(.facebook)

    public enum Service {

        typealias BackgroundColor = (normal: Color, active: Color)

        case apple
        case google
        case facebook
        case email

        @ViewBuilder var logo: some View {
            switch self {
                case .apple:
                    if #available(iOS 14.0, *) {
                        SocialButton.appleLogo
                            .font(.system(size: 20))
                            .foregroundColor(.white)
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

        var backgroundColor: BackgroundColor {
            switch self {
                case .apple:                                return (.black, .inkNormal)
                case .google:                               return (.cloudDark, .cloudNormalActive)
                case .facebook:                             return (.cloudDark, .cloudNormalActive)
                case .email:                                return (.cloudDark, .cloudNormalActive)
            }
        }

        var labelColor: Color {
            switch self {
                case .apple:                                return .white
                case .google:                               return .inkNormal
                case .facebook:                             return .inkNormal
                case .email:                                return .inkNormal
            }
        }
    }

    struct OrbitStyle: ButtonStyle {

        var service: Service

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(minWidth: Layout.preferredButtonHeight, maxWidth: .infinity)
                .padding(.horizontal, .small)
                .frame(height: Layout.preferredButtonHeight)
                .foregroundColor(service.labelColor)
                .background(
                    configuration.isPressed ? service.backgroundColor.active : service.backgroundColor.normal
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
            storybook
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        SocialButton("Sign in with Facebook", service: .facebook)
            .padding(.medium)
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            SocialButton("Sign in with E-mail", service: .email)
            SocialButton("Sign in with Facebook", service: .facebook)
            SocialButton("Sign in with Google", service: .google)
            SocialButton("Sign in with Apple", service: .apple)
        }
        .padding(.medium)
    }
}

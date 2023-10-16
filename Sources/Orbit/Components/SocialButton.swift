import SwiftUI

/// Lets users sign in using a social service.
///
/// Social buttons are designed to ease the flow for users signing in.
/// Don’t use them in any other case or in any complex scenarios.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/socialbutton/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct SocialButton: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.sizeCategory) private var sizeCategory

    private let label: String
    private let service: Service
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button {
            action()
        } label: {
            Text(label)
                .fontWeight(.medium)
        }
        .buttonStyle(
            OrbitCustomButtonStyle(isTrailingIconSeparated: true) {
                logo
                    .scaledToFit()
                    .frame(width: .large * sizeCategory.ratio)
                    .padding([.leading, .vertical], -.xxSmall)
            } disclosureIcon: {
                Icon(.chevronForward)
                    .iconSize(.large)
                    .padding([.trailing, .vertical], -.xxSmall)
            }
        )
        .textColor(textColor)
        .backgroundColor(background, active: backgroundActive)
    }

    @ViewBuilder var logo: some View {
        switch service {
            case .apple:        Self.appleLogo.foregroundColor(.whiteNormal).padding(1)
            case .google:       Self.googleLogo
            case .facebook:     Self.facebookLogo
            case .email:        Icon(.email).iconSize(.large)
        }
    }

    var textColor: Color {
        switch service {
            case .apple:        return .whiteNormal
            case .google:       return .inkDark
            case .facebook:     return .inkDark
            case .email:        return .inkDark
        }
    }

    var background: Color {
        switch service {
            case .apple:        return colorScheme == .light ? .black : .white
            case .google:       return .cloudNormal
            case .facebook:     return .cloudNormal
            case .email:        return .cloudNormal
        }
    }

    var backgroundActive: Color {
        switch service {
            case .apple:        return colorScheme == .light ? .inkNormalActive : .inkNormalActive
            case .google:       return .cloudNormalActive
            case .facebook:     return .cloudNormalActive
            case .email:        return .cloudNormalActive
        }
    }
}

// MARK: - Inits
public extension SocialButton {
    
    /// Creates Orbit SocialButton component.
    init(_ label: String, service: Service, action: @escaping () -> Void) {
        self.label = label
        self.service = service
        self.action = action
    }
}

// MARK: - Types
extension SocialButton {

    private static let appleLogo = Image.orbit(.apple).renderingMode(.template).resizable()
    private static let googleLogo = Image.orbit(.google).resizable()
    private static let facebookLogo = Image.orbit(.facebook).resizable()

    public enum Service {
        case apple
        case google
        case facebook
        case email
    }
}

// MARK: - Previews
struct SocialButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            idealSize
            sizing
            all
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        SocialButton("Sign in with Facebook", service: .facebook, action: {})
            .previewDisplayName()
    }

    static var idealSize: some View {
        content
            .idealSize()
            .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                SocialButton("Sign in with Apple", service: .apple, action: {})
                SocialButton("Sign in with Facebook", service: .facebook, action: {})
                SocialButton("Sign in with Facebook", service: .facebook, action: {})
                    .idealSize()
                    .buttonSize(.compact)
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var all: some View {
        content
            .previewDisplayName()
    }

    static var content: some View {
        VStack(spacing: .medium) {
            SocialButton("Sign in with E-mail", service: .email, action: {})
            SocialButton("Sign in with Facebook", service: .facebook, action: {})
            SocialButton("Sign in with Google", service: .google, action: {})
            SocialButton("Sign in with Apple", service: .apple, action: {})
        }
    }

    static var snapshot: some View {
        VStack(spacing: .medium) {
            all
            idealSize
            sizing
        }
        .padding(.medium)
    }
}

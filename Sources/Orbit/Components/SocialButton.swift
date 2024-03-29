import SwiftUI

/// Orbit component that displays a control that initiates an action related to a social service. 
///
/// A ``SocialButton`` consists of a label and predefined icon.
///
/// ```swift
/// SocialButton("Sign in with Facebook", service: .facebook) {
///     // Tap action 
/// }
/// ```
///
/// Before the action is triggered, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier.
/// The default ``ButtonSize/regular`` size can be modified by a ``buttonSize(_:)`` modifier.
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/socialbutton/)
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
        }
        .buttonStyle(
            OrbitButtonStyle {
                logo
                    .scaledToFit()
                    .frame(width: .large * sizeCategory.ratio)
                    .padding(.vertical, -.xxSmall)
            } trailingIcon: {
                Spacer(minLength: 0)
                Icon(.chevronForward)
                    .iconSize(.large)
                    .padding(.vertical, -.xxSmall)
            }
        )
        .textColor(textColor)
        .backgroundStyle(background, active: backgroundActive)
    }

    @ViewBuilder private var logo: some View {
        switch service {
            case .apple:        Self.appleLogo.foregroundColor(.whiteNormal).padding(1)
            case .google:       Self.googleLogo
            case .facebook:     Self.facebookLogo
            case .email:        Icon(.email).iconSize(.large)
        }
    }

    private var textColor: Color {
        switch service {
            case .apple:        return .whiteNormal
            case .google:       return .inkDark
            case .facebook:     return .inkDark
            case .email:        return .inkDark
        }
    }

    private var background: Color {
        switch service {
            case .apple:        return colorScheme == .light ? .black : .white
            case .google:       return .cloudNormal
            case .facebook:     return .cloudNormal
            case .email:        return .cloudNormal
        }
    }

    private var backgroundActive: Color {
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
    
    /// Creates Orbit ``SocialButton`` component.
    init(_ label: String, service: Service, action: @escaping () -> Void) {
        self.label = label
        self.service = service
        self.action = action
    }
}

// MARK: - Types
extension SocialButton {

    private static let appleLogo = Image(.apple).renderingMode(.template).resizable()
    private static let googleLogo = Image(.google).resizable()
    private static let facebookLogo = Image(.facebook).resizable()

    /// Orbit ``SocialButton`` social service or login method.
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

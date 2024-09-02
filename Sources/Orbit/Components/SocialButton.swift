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
public struct SocialButton<Label: View, Icon: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.sizeCategory) private var sizeCategory
    
    private let service: SocialButtonService?
    private let action: () -> Void
    @ViewBuilder private let label: Label
    @ViewBuilder private let icon: Icon
    
    public var body: some View {
        SwiftUI.Button {
            action()
        } label: {
            label
        }
        .buttonStyle(
            OrbitButtonStyle {
                icon
                    .scaledToFit()
                    .frame(width: .large * sizeCategory.ratio)
                    .padding(.vertical, -.xxSmall)
            } trailingIcon: {
                Spacer(minLength: 0)
                Orbit.Icon(.chevronForward)
                    .iconSize(.large)
                    .padding(.vertical, -.xxSmall)
            }
        )
        .textColor(textColor)
        .backgroundStyle(background, active: backgroundActive)
    }
    
    private var textColor: Color {
        switch service {
            case .apple:    .whiteNormal
            default:        .inkDark
        }
    }
    
    private var background: Color {
        switch service {
            case .apple:    colorScheme == .light ? .black : .white
            default:        .cloudNormal
        }
    }
    
    private var backgroundActive: Color {
        switch service {
            case .apple:    colorScheme == .light ? .inkNormalActive : .inkNormalActive
            default:        .cloudNormalActive
        }
    }
    
    /// Creates Orbit ``SocialButton`` component with custom content.
    public init(
        service: SocialButtonService? = nil,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label,
        @ViewBuilder icon: () -> Icon
    ) {
        self.service = service
        self.action = action
        self.label = label()
        self.icon = icon()
    }
}

// MARK: - Convenience Inits
public extension SocialButton where Label == Text, Icon == SocialButtonIcon {
    
    /// Creates Orbit ``SocialButton`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        service: SocialButtonService,
        action: @escaping () -> Void
    ) {
        self.init(service: service) {
            action()
        } label: {
            Text(label)
        } icon: {
            SocialButtonIcon(service)
        }
    }
    
    /// Creates Orbit ``SocialButton`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey = "",
        service: SocialButtonService,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        action: @escaping () -> Void
    ) {
        self.init(service: service) {
            action()
        } label: {
            Text(label, tableName: tableName, bundle: bundle)
        } icon: {
            SocialButtonIcon(service)
        }
    }
}

// MARK: - Previews
struct SocialButtonPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            idealSize
            sizing
            custom
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
    
    static var custom: some View {
        SocialButton {
            // No action
        } label: {
            Text("Custom service")
        } icon: {
            Icon(.admin)
        }
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

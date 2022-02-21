import SwiftUI

/// Displays a single, less important action a user can take.
///
/// - Related components:
///   - ``Button``
///   - ``TextLink``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/buttonlink/)
/// - Important: Component has the same height as a ``Button``, but does not expand horizontally.
public struct ButtonLink: View {

    public static let defaultHeight: CGFloat = 20
    
    let label: String
    let style: Style
    let iconContent: Icon.Content
    let size: Size
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                HStack(spacing: .xSmall) {
                    iconContent.view()
                    
                    Text(
                        label,
                        size: .normal,
                        color: nil,
                        weight: .medium,
                        accentColor: style.color.normal,
                        linkColor: style.color.normal
                    )
                }
            }
        )
        .buttonStyle(OrbitStyle(style: style, size: size))
    }
}

// MARK: - Inits
public extension ButtonLink {

    /// Creates Orbit ButtonLink component.
    init(
        _ label: String = "",
        style: Style = .primary,
        iconContent: Icon.Content = .none,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.style = style
        self.iconContent = iconContent
        self.size = size
        self.action = action
    }

    /// Creates Orbit ButtonLink component with icon symbol.
    init(
        _ label: String = "",
        style: Style = .primary,
        icon: Icon.Symbol = .none,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            iconContent: .icon(icon, size: .small),
            size: size,
            action: action
        )
    }
    
    /// Creates Orbit ButtonLink component with no icon.
    init(
        _ label: String = "",
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            iconContent: .none,
            size: size,
            action: action
        )
    }
}

// MARK: - Types
public extension ButtonLink {

    enum Style {
        case primary
        case secondary
        case critical
        case status(_ status: Status)
        case custom(colors: (normal: UIColor, active: UIColor))

        public var color: (normal: UIColor, active: UIColor) {
            switch self {
                case .primary:              return (.productNormal, .productLightActive)
                case .secondary:            return (.inkNormal, .cloudDarker)
                case .critical:             return (.redNormal, .redLightActive)
                case .status(.info):        return (.blueNormal, .blueLightActive)
                case .status(.success):     return (.greenNormal, .greenLightActive)
                case .status(.warning):     return (.orangeNormal, .orangeLightActive)
                case .status(.critical):    return (.redNormal, .redLightActive)
                case .custom(let colors):   return colors
            }
        }
    }

    enum Size {
        case `default`
        case button
        case buttonSmall

        public var height: CGFloat {
            switch self {
                case .default:              return ButtonLink.defaultHeight
                case .button:               return Layout.preferredButtonHeight
                case .buttonSmall:          return Layout.preferredSmallButtonHeight
            }
        }
        
        public var maxWidth: CGFloat? {
            switch self {
                case .default:                  return nil
                case .button, .buttonSmall:     return .infinity
            }
        }
    }
    
    struct OrbitStyle: ButtonStyle {

        let style: Style
        let size: ButtonLink.Size

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(Color(configuration.isPressed ? style.color.active : style.color.normal))
                .frame(height: size.height)
                .frame(maxWidth: size.maxWidth)
                .contentShape(Rectangle())
        }
    }
}

// MARK: - Previews
struct ButtonLinkPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            
            styles
                .padding(.medium)
                .previewDisplayName("Styles")
            
            withIcon
                .padding(.medium)
                .previewDisplayName("With icon")
            
            status
                .padding(.medium)
                .previewDisplayName("Status")
            
            size
                .padding(.medium)
                .previewDisplayName("Size")
            
            snapshotsCustom
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ButtonLink("ButtonLink")
    }

    static var styles: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("Primary", style: .primary)
            ButtonLink("Secondary", style: .secondary)
            ButtonLink("Critical", style: .critical)
        }
    }
    
    static var withIcon: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("Primary", style: .primary, icon: .accommodation)
            ButtonLink("Secondary", style: .secondary, icon: .airplaneDown)
            ButtonLink("Critical", style: .critical, icon: .alertCircle)
        }
    }
    
    static var status: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("Info", style: .status(.info), icon: .informationCircle)
            ButtonLink("Success", style: .status(.success), icon: .checkCircle)
            ButtonLink("Warning", style: .status(.warning), icon: .alert)
            ButtonLink("Critical", style: .status(.critical), icon: .alertCircle)
        }
    }
    
    static var size: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("Size Default (20)", icon: .baggageSet)
                .border(Color.cloudNormal)
            ButtonLink("Size ButtonSmall", icon: .baggageSet, size: .buttonSmall)
                .border(Color.cloudNormal)
            ButtonLink("Size Button", icon: .baggageSet, size: .button)
                .border(Color.cloudNormal)
        }
    }
    
    static var orbit: some View {
        VStack(spacing: 0) {
            styles
            Separator()
            withIcon
            Separator()
            status
            Separator()
            size
        }
        .padding()
    }

    static var snapshots: some View {
        orbit
    }

    static var snapshotsCustom: some View {
        Group {
            ButtonLink(
                "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
                style: .custom(colors: (normal: .blueDark, active: .blueNormal)),
                icon: .kiwicom
            )
            .previewDisplayName("Custom")

            ButtonLink(icon: .kiwicom)
                .background(Color.blueLight)
                .padding(.vertical)
                .previewDisplayName("Icon only")
        }
        .padding(.horizontal)
    }
}

import SwiftUI

/// Displays a single, less important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/buttonlink/)
public struct ButtonLink: View {

    let label: String
    let style: Style
    let iconContent: Icon.Content
    let size: Size
    let action: () -> Void

    public var body: some View {
        if label.isEmpty == false {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    action()
                },
                label: {
                    HStack(spacing: .xSmall) {
                        Icon(content: iconContent)

                        Text(
                            label,
                            color: nil,
                            weight: .medium,
                            accentColor: style.color.normal,
                            linkColor: .custom(style.color.normal)
                        )
                    }
                    .padding(.vertical, verticalPadding)
                }
            )
            .buttonStyle(OrbitStyle(style: style, size: size))
        }
    }

    var verticalPadding: CGFloat {
        switch size {
            case .default:              return 0
            case .button:               return .small   // = 44 height @ normal size
            case .buttonSmall:          return 6        // = 32 height @ normal size
        }
    }
}

// MARK: - Inits
public extension ButtonLink {

    /// Creates Orbit ButtonLink component.
    init(
        _ label: String = "",
        style: Style = .primary,
        icon: Icon.Content = .none,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.style = style
        self.iconContent = icon
        self.size = size
        self.action = action
    }
}

// MARK: - Types
public extension ButtonLink {

    enum Style: Equatable {
        case primary
        case secondary
        case critical
        case status(_ status: Status)
        case custom(colors: (normal: UIColor, active: UIColor))

        public var color: (normal: UIColor, active: UIColor) {
            switch self {
                case .primary:              return (.productNormal, .productLightActive)
                case .secondary:            return (.inkDark, .cloudDark)
                case .critical:             return (.redNormal, .redLightActive)
                case .status(.info):        return (.blueNormal, .blueLightActive)
                case .status(.success):     return (.greenNormal, .greenLightActive)
                case .status(.warning):     return (.orangeNormal, .orangeLightActive)
                case .status(.critical):    return (.redNormal, .redLightActive)
                case .custom(let colors):   return colors
            }
        }

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case
                    (.primary, .primary),
                    (.secondary, .secondary),
                    (.critical, .critical),
                    (.custom, .custom):
                    return true
                case (.status(let lstatus), .status(let rstatus)) where lstatus == rstatus:
                    return true
                default:
                    return false
            }
        }
    }

    enum Size {
        case `default`
        case button
        case buttonSmall
        
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
            sizing
            formatted
            iconOnly
            countryFlag
            styles
            statuses
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            ButtonLink("ButtonLink")
            ButtonLink("") // EmptyView
            ButtonLink()   // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Group {
                ButtonLink("ButtonLink intrinsic")
                ButtonLink("ButtonLink intrinsic", icon: .grid)
                ButtonLink("ButtonLink button", size: .button)
                ButtonLink("ButtonLink button", icon: .grid, size: .button)
                ButtonLink("ButtonLink small button", size: .buttonSmall)
                ButtonLink("ButtonLink small button", icon: .grid, size: .buttonSmall)
            }
            .border(Color.cloudNormal)
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary)
                ButtonLink("ButtonLink Secondary", style: .secondary)
                ButtonLink("ButtonLink Critical", style: .critical)
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary, icon: .accommodation)
                ButtonLink("ButtonLink Secondary", style: .secondary, icon: .airplaneDown)
                ButtonLink("ButtonLink Critical", style: .critical, icon: .alertCircle)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var statuses: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", style: .status(.info), icon: .informationCircle)
            ButtonLink("ButtonLink Success", style: .status(.success), icon: .checkCircle)
            ButtonLink("ButtonLink Warning", style: .status(.warning), icon: .alert)
            ButtonLink("ButtonLink Critical", style: .status(.critical), icon: .alertCircle)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var formatted: some View {
        ButtonLink(
            "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
            style: .custom(colors: (normal: .blueDark, active: .blueNormal)),
            icon: .kiwicom
        )
        .padding(.medium)
        .previewDisplayName()
    }

    static var iconOnly: some View {
        ButtonLink(icon: .kiwicom)
            .background(Color.blueLight)
            .padding(.medium)
            .previewDisplayName()
    }

    static var countryFlag: some View {
        ButtonLink("Flag", icon: .countryFlag("us"))
            .padding(.medium)
            .previewDisplayName()
    }
}

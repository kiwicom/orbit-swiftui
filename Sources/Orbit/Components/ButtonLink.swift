import SwiftUI

/// Displays a single, less important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/buttonlink/)
public struct ButtonLink: View {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor

    let label: String
    let style: Style
    let icon: Icon.Content?
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
                        Icon(icon)
                            .fontWeight(.medium)

                        Text(label)
                            .fontWeight(.medium)
                            // Ignore any potential `TextLinks`
                            .allowsHitTesting(false)
                            .textLinkColor(.custom(colors.normal))
                    }
                    .padding(.vertical, verticalPadding)
                }
            )
            .buttonStyle(OrbitStyle(colors: textColors ?? colors, size: size))
        }
    }

    public var colors: (normal: Color, active: Color) {
        switch style {
            case .primary:              return (.productNormal, .productLightActive)
            case .secondary:            return (.inkDark, .cloudDark)
            case .critical:             return (.redNormal, .redLightActive)
            case .status(let status):   return (status ?? defaultStatus).colors
        }
    }

    public var textColors: (normal: Color, active: Color)? {
        textColor.map { (normal: $0, active: $0.opacity(0.5)) }
    }

    var defaultStatus: Status {
        status ?? .info
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
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String = "",
        style: Style = .primary,
        icon: Icon.Content? = nil,
        size: Size = .default,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.icon = icon
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
        case status(_ status: Status?)

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case
                    (.primary, .primary),
                    (.secondary, .secondary),
                    (.critical, .critical):
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

        let colors: (normal: Color, active: Color)
        let size: ButtonLink.Size

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .textColor(configuration.isPressed ? colors.active : colors.normal)
                .frame(maxWidth: size.maxWidth)
                .contentShape(Rectangle())
        }
    }
}

private extension Status {

    var colors: (normal: Color, active: Color) {
        (color, lightActiveColor)
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
            ButtonLink("ButtonLink", action: {})
            ButtonLink("", action: {}) // EmptyView
            ButtonLink(action: {})   // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Group {
                ButtonLink("ButtonLink intrinsic", action: {})
                ButtonLink("ButtonLink intrinsic", icon: .grid, action: {})
                ButtonLink("ButtonLink button", size: .button, action: {})
                ButtonLink("ButtonLink button", icon: .grid, size: .button, action: {})
                ButtonLink("ButtonLink small button", size: .buttonSmall, action: {})
                ButtonLink("ButtonLink small button", icon: .grid, size: .buttonSmall, action: {})
            }
            .border(.cloudNormal)
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary, action: {})
                ButtonLink("ButtonLink Secondary", style: .secondary, action: {})
                ButtonLink("ButtonLink Critical", style: .critical, action: {})
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary, icon: .accommodation, action: {})
                ButtonLink("ButtonLink Secondary", style: .secondary, icon: .airplaneDown, action: {})
                ButtonLink("ButtonLink Critical", style: .critical, icon: .alertCircle, action: {})
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var statuses: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", style: .status(.info), icon: .informationCircle, action: {})
            ButtonLink("ButtonLink Success", style: .status(.success), icon: .checkCircle, action: {})
            ButtonLink("ButtonLink Warning", style: .status(.warning), icon: .alert, action: {})
            ButtonLink("ButtonLink Critical", style: .status(.critical), icon: .alertCircle, action: {})
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var formatted: some View {
        ButtonLink(
            "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
            style: .primary,
            icon: .kiwicom,
            action: {}
        )
        .textAccentColor(Status.success.darkColor)
        .textLinkColor(.status(.critical))
        .padding(.medium)
        .previewDisplayName()
    }

    static var iconOnly: some View {
        ButtonLink(icon: .kiwicom, action: {})
            .background(Color.blueLight)
            .padding(.medium)
            .previewDisplayName()
    }

    static var countryFlag: some View {
        ButtonLink("Flag", icon: .countryFlag("us"), action: {})
            .padding(.medium)
            .previewDisplayName()
    }
}

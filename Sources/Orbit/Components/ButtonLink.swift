import SwiftUI

/// Displays a single, less important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/buttonlink/)
public struct ButtonLink<Icon: View>: View {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    let label: String
    let type: ButtonLinkType
    let size: ButtonLinkSize
    let action: () -> Void
    @ViewBuilder let icon: Icon

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button(
                action: {
                    if isHapticsEnabled {
                        HapticsProvider.sendHapticFeedback(.light(0.5))
                    }
                    
                    action()
                },
                label: {
                    HStack(spacing: .xSmall) {
                        icon
                            .textFontWeight(.medium)
                            .font(.system(size: Orbit.Icon.Size.normal.value))

                        Text(label)
                            .fontWeight(.medium)
                            // Ignore any potential `TextLinks`
                            .allowsHitTesting(false)
                            .textLinkColor(.custom(colors.normal))
                    }
                    .padding(.vertical, verticalPadding)
                }
            )
            .buttonStyle(ButtonLinkButtonStyle(colors: textColors ?? colors, size: size))
        }
    }

    public var colors: (normal: Color, active: Color) {
        switch type {
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

    var isEmpty: Bool {
        label.isEmpty && icon.isEmpty
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
        type: ButtonLinkType = .primary,
        icon: Icon.Symbol? = nil,
        size: ButtonLinkSize = .default,
        action: @escaping () -> Void
    ) where Icon == Orbit.Icon {
        self.init(
            label,
            type: type,
            size: size
        ) {
            action()
        } icon: {
            Icon(icon)
        }
    }

    /// Creates Orbit ButtonLink component with custom icon.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String = "",
        type: ButtonLinkType = .primary,
        size: ButtonLinkSize = .default,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
        self.label = label
        self.type = type
        self.size = size
        self.action = action
        self.icon = icon()
    }
}

// MARK: - Types

public enum ButtonLinkType: Equatable {

    case primary
    case secondary
    case critical
    case status(_ status: Status?)
}

public enum ButtonLinkSize: Equatable {
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

public struct ButtonLinkButtonStyle: ButtonStyle {

    let colors: (normal: Color, active: Color)
    let size: ButtonLinkSize

    public init(colors: (normal: Color, active: Color), size: ButtonLinkSize) {
        self.colors = colors
        self.size = size
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textColor(configuration.isPressed ? colors.active : colors.normal)
            .frame(maxWidth: size.maxWidth)
            .contentShape(Rectangle())
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
                ButtonLink("ButtonLink Primary", type: .primary, action: {})
                ButtonLink("ButtonLink Secondary", type: .secondary, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, action: {})
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", type: .primary, icon: .accommodation, action: {})
                ButtonLink("ButtonLink Secondary", type: .secondary, icon: .airplaneDown, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, icon: .alertCircle, action: {})
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var statuses: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", type: .status(.info), icon: .informationCircle, action: {})
            ButtonLink("ButtonLink Success", type: .status(.success), icon: .checkCircle, action: {})
            ButtonLink("ButtonLink Warning", type: .status(.warning), icon: .alert, action: {})
            ButtonLink("ButtonLink Critical", type: .status(.critical), icon: .alertCircle, action: {})
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var formatted: some View {
        ButtonLink(
            "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
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
            .padding(.medium)
            .previewDisplayName()
    }
}

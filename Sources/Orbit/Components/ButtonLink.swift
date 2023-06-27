import SwiftUI

/// Displays a single, less important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/buttonlink/)
public struct ButtonLink<LeadingIcon: View, TrailingIcon: View>: View {

    @Environment(\.suppressButtonStyle) var suppressButtonStyle

    private let label: String
    private let type: ButtonLinkType
    private let action: () -> Void
    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let trailingIcon: TrailingIcon

    public var body: some View {
        if isEmpty == false {
            if suppressButtonStyle {
                button
            } else {
                button
                    .buttonStyle(
                        OrbitButtonLinkButtonStyle(type: type) {
                            leadingIcon
                        } trailingIcon: {
                            trailingIcon
                        }
                    )
            }
        }
    }

    @ViewBuilder var button: some View {
        SwiftUI.Button() {
            action()
        } label: {
            Text(label)
        }
    }

    var isEmpty: Bool {
        label.isEmpty && leadingIcon.isEmpty && trailingIcon.isEmpty
    }
}

// MARK: - Inits
public extension ButtonLink {

    /// Creates Orbit ButtonLink component.
    ///
    /// Button size can be specified using `.buttonSize()` modifier.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A style can be optionally modified using `status()` modifier when `nil` status value is provided.
    init(
        _ label: String = "",
        type: ButtonLinkType = .primary,
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        action: @escaping () -> Void
    ) where LeadingIcon == Orbit.Icon, TrailingIcon == Orbit.Icon  {
        self.init(label, type: type) {
            action()
        } icon: {
            Icon(icon)
        } disclosureIcon: {
            Icon(disclosureIcon)
        }
    }

    /// Creates Orbit ButtonLink component with custom icons.
    ///
    /// Button size can be specified using `.buttonSize()` modifier.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A style can be optionally modified using `status()` modifier when `nil` status value is provided.
    init(
        _ label: String = "",
        type: ButtonLinkType = .primary,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> LeadingIcon,
        @ViewBuilder disclosureIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.label = label
        self.type = type
        self.action = action
        self.leadingIcon = icon()
        self.trailingIcon = disclosureIcon()
    }
}

// MARK: - Types

public enum ButtonLinkType: Equatable {
    case primary
    case critical
    case status(_ status: Status?)
}

/// Button style matching Orbit ButtonLink component.
public struct OrbitButtonLinkButtonStyle<LeadingIcon: View, TrailingIcon: View>: PrimitiveButtonStyle {

    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.status) private var status

    private var type: ButtonLinkType
    @ViewBuilder private let icon: LeadingIcon
    @ViewBuilder private let disclosureIcon: TrailingIcon

    public init(
        type: ButtonLinkType,
        @ViewBuilder icon: () -> LeadingIcon,
        @ViewBuilder trailingIcon: () -> TrailingIcon
    ) {
        self.type = type
        self.icon = icon()
        self.disclosureIcon = trailingIcon()
    }

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textColor: textColor,
            textActiveColor: textActiveColor,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            horizontalBackgroundPadding: horizontalBackgroundPadding,
            verticalBackgroundPadding: verticalBackgroundPadding,
            hapticFeedback: hapticFeedback
        ) {
            icon
        } disclosureIcon: {
            disclosureIcon
        } background: {
            Color.clear
        } backgroundActive: {
            backgroundActive
        }
        .textFontWeight(.medium)
        .idealSize(horizontal: buttonSize == .compact)
    }

    @ViewBuilder var backgroundActive: some View {
        switch type {
            case .primary:                      Color.productLightActive
            case .critical:                     Color.redLightActive
            case .status(let status):           (status ?? defaultStatus).lightActiveColor
        }
    }

    var textColor: Color {
        switch type {
            case .primary:                      return .productNormal
            case .critical:                     return .redNormal
            case .status(let status):           return (status ?? defaultStatus).color
        }
    }

    var textActiveColor: Color {
        switch type {
            case .primary:                      return .productDarkActive
            case .critical:                     return .redDarkActive
            case .status(let status):           return (status ?? defaultStatus).darkHoverColor
        }
    }

    var defaultStatus: Status {
        status ?? .info
    }


    var resolvedStatus: Status {
        switch type {
            case .status(let status):   return status ?? self.status ?? .info
            default:                    return .info
        }
    }

    var hapticFeedback: HapticsProvider.HapticFeedbackType {
        switch type {
            case .primary:                      return .light(1)
            case .critical:                 	return .notification(.error)
            case .status:
                switch resolvedStatus {
                    case .info, .success:       return .light(0.5)
                    case .warning:              return .notification(.warning)
                    case .critical:             return .notification(.error)
                }
        }
    }

    var horizontalPadding: CGFloat {
        switch buttonSize {
            case .default:  return .medium
            case .compact:  return 0
        }
    }

    var verticalPadding: CGFloat {
        switch buttonSize {
            case .default:  return .small   // = 44 height @ normal size
            case .compact:  return 6        // = 32 height @ normal size
        }
    }

    var horizontalBackgroundPadding: CGFloat {
        switch buttonSize {
            case .default:  return 0
            case .compact:  return .xSmall
        }
    }

    var verticalBackgroundPadding: CGFloat {
        switch buttonSize {
            case .default:  return 0
            case .compact:  return .xxxSmall
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
            styles
            statuses
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            ButtonLink("ButtonLink", action: {})
            ButtonLink("ButtonLink", type: .critical, action: {})
            ButtonLink("ButtonLink", action: {})
                .buttonSize(.compact)
            ButtonLink("", action: {}) // EmptyView
            ButtonLink(action: {})   // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Group {
                ButtonLink("ButtonLink", action: {})
                ButtonLink("ButtonLink", icon: .grid, action: {})
                ButtonLink("ButtonLink Compact", action: {})
                    .buttonSize(.compact)
                ButtonLink("ButtonLink Compact", icon: .grid, action: {})
                    .buttonSize(.compact)
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
                ButtonLink("ButtonLink Critical", type: .critical, action: {})
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", type: .primary, icon: .accommodation, action: {})
                ButtonLink("ButtonLink Critical", type: .critical, icon: .alertCircle, action: {})
            }
        }
        .buttonSize(.compact)
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
        .buttonSize(.compact)
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

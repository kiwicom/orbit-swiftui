import SwiftUI

/// Displays a single important action a user can take.
///
/// - Related components:
///   - ``ButtonLink``
///   - ``TextLink``
///   - ``SocialButton``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/button/)
/// - Important: Component expands horizontally to infinity.
public struct Button: View {

    let label: String
    let style: Style
    let iconContent: Icon.Content
    let disclosureIconContent: Icon.Content
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                presentHapticFeedback()
                action()
            },
            label: {
                HStack(spacing: .xSmall) {
                    if disclosureIconContent.isEmpty {
                        Spacer(minLength: 0)
                    }

                    iconContent.view()

                    if #available(iOS 14.0, *) {
                        Text(
                            label,
                            size: .normal,
                            color: .custom(style.foregroundUIColor),
                            weight: .medium,
                            linkColor: style.foregroundUIColor
                        )
                    } else {
                        Text(
                            label,
                            size: .normal,
                            color: .custom(style.foregroundUIColor),
                            weight: .medium,
                            linkColor: style.foregroundUIColor
                        )
                        // Prevents text value animation issue due to different iOS13 behavior
                        .animation(nil)
                    }

                    Spacer(minLength: 0)

                    if disclosureIconContent.isEmpty == false {
                        disclosureIconContent.view()
                    }
                }
                .padding(.horizontal, label.isEmpty ? 0 : .small)
            }
        )
        .buttonStyle(OrbitStyle(style: style))
        .frame(minWidth: Layout.preferredButtonHeight, maxWidth: .infinity)
        .frame(width: isIconOnly ? Layout.preferredButtonHeight : nil)
    }

    var isIconOnly: Bool {
        iconContent.isEmpty == false && label.isEmpty
    }

    func presentHapticFeedback() {
        switch style {
            case .primary:
                HapticsProvider.sendHapticFeedback(.light(1))
            case .primarySubtle, .secondary, .status(.info, _):
                HapticsProvider.sendHapticFeedback(.light(0.5))
            case .critical, .criticalSubtle, .status(.critical, _):
                HapticsProvider.sendHapticFeedback(.notification(.error))
            case .status(.warning, _):
                HapticsProvider.sendHapticFeedback(.notification(.warning))
            case .status(.success, _):
                HapticsProvider.sendHapticFeedback(.light(0.5))
        }
    }
}

// MARK: - Inits
public extension Button {

    /// Creates Orbit Button component.
    init(
        _ label: String,
        style: Style = .primary,
        iconContent: Icon.Content = .none,
        disclosureIconContent: Icon.Content = .none,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.style = style
        self.iconContent = iconContent
        self.disclosureIconContent = disclosureIconContent
        self.action = action
    }

    /// Creates Orbit Button component with icon symbol.
    init(
        _ label: String,
        style: Style = .primary,
        icon: Icon.Symbol = .none,
        disclosureIcon: Icon.Symbol = .none,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            iconContent: .icon(icon, color: style.foregroundColor),
            disclosureIconContent: .icon(disclosureIcon, color: style.foregroundColor),
            action: action
        )
    }
    
    /// Creates Orbit Button component with no icon.
    init(
        _ label: String,
        style: Style = .primary,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            iconContent: .none,
            disclosureIconContent: .none,
            action: action
        )
    }

    /// Creates Orbit Button component with icon only.
    init(_ icon: Icon.Symbol = .none, style: Style = .primary, action: @escaping () -> Void = {}) {
        self.init(
            "",
            style: style,
            icon: icon,
            disclosureIcon: .none,
            action: action
        )
    }
}

// MARK: - Types
extension Button {

    public enum Style {
        case primary
        case primarySubtle
        case secondary
        case critical
        case criticalSubtle
        case status(_ status: Status, subtle: Bool = false)

        var foregroundColor: Color {
            switch self {
                case .primary:                  return .white
                case .primarySubtle:            return .productNormal
                case .secondary:                return .inkNormal
                case .critical:                 return .white
                case .criticalSubtle:           return .redNormal
                case .status(.critical, false): return .white
                case .status(.critical, true):  return .redNormalHover
                case .status(.info, false):     return .white
                case .status(.info, true):      return .blueNormalHover
                case .status(.success, false):  return .white
                case .status(.success, true):   return .greenNormalHover
                case .status(.warning, false):  return .white
                case .status(.warning, true):   return .orangeNormalHover
            }
        }

        var foregroundUIColor: UIColor {
            switch self {
                case .primary:                  return .white
                case .primarySubtle:            return .productNormal
                case .secondary:                return .inkNormal
                case .critical:                 return .white
                case .criticalSubtle:           return .redNormal
                case .status(.critical, false): return .white
                case .status(.critical, true):  return .redNormalHover
                case .status(.info, false):     return .white
                case .status(.info, true):      return .blueNormalHover
                case .status(.success, false):  return .white
                case .status(.success, true):   return .greenNormalHover
                case .status(.warning, false):  return .white
                case .status(.warning, true):   return .orangeNormalHover
            }
        }

        var backgroundColor: (normal: Color, active: Color) {
            switch self {
                case .primary:                  return (.productNormal, .productNormalActive)
                case .primarySubtle:            return (.productLight, .productLightActive)
                case .secondary:                return (.cloudDark, .cloudNormalActive)
                case .critical:                 return (.redNormal, .redNormalActive)
                case .criticalSubtle:           return (.redLight, .redLightActive)
                case .status(.critical, false): return (.redNormal, .redNormalActive)
                case .status(.critical, true):  return (.redLightHover, .redLightActive)
                case .status(.info, false):     return (.blueNormal, .blueNormalActive)
                case .status(.info, true):      return (.blueLightHover, .blueLightActive)
                case .status(.success, false):  return (.greenNormal, .greenNormalActive)
                case .status(.success, true):   return (.greenLightHover, .greenLightActive)
                case .status(.warning, false):  return (.orangeNormal, .orangeNormalActive)
                case .status(.warning, true):   return (.orangeLightHover, .orangeLightActive)
            }
        }
    }

    private struct OrbitStyle: ButtonStyle {

        var style: Style

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(height: Layout.preferredButtonHeight)
                .background(
                    configuration.isPressed ? style.backgroundColor.active : style.backgroundColor.normal
                )
                .cornerRadius(BorderRadius.default)
        }
    }
}

// MARK: - Previews
struct ButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
    }

    static var standalone: some View {
        Button("Primary Button")
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Standalone")
    }

    @ViewBuilder static var orbit: some View {
        VStack(spacing: .medium) {
            HStack(spacing: .medium) {
                Button("Primary", style: .primary)
                Button("Primary Subtle", style: .primarySubtle)
            }
            Button("Secondary", style: .secondary)
            HStack(spacing: .medium) {
                Button("Critical", style: .critical)
                Button("Critical Subtle", style: .criticalSubtle)
            }
        }
        .padding(.vertical)
        .previewDisplayName("Main buttons")

        VStack(spacing: .medium) {
            HStack(spacing: .medium) {
                Button("Info", style: .status(.info))
                Button("Info Subtle", style: .status(.info, subtle: true))
            }
            HStack(spacing: .medium) {
                Button("Success", style: .status(.success))
                Button("Success Subtle", style: .status(.success, subtle: true))
            }
            HStack(spacing: .medium) {
                Button("Warning", style: .status(.warning))
                Button("Warning Subtle", style: .status(.warning, subtle: true))
            }
            HStack(spacing: .medium) {
                Button("Critical", style: .status(.critical))
                Button("Critical Subtle", style: .status(.critical, subtle: true))
            }
        }
        .padding(.vertical)
        .previewDisplayName("Status buttons")

        VStack(spacing: .medium) {
            Button("Secondary with icon", style: .secondary, icon: .email)
            Button("Primary with Icons", style: .primary, icon: .flightNomad, disclosureIcon: .chevronRight)
            Button("Secondary with Icons", style: .secondary, icon: .flightDirect, disclosureIcon: .chevronRight)
            Button("Info with Icons", style: .status(.info), icon: .flightDirect, disclosureIcon: .chevronRight)

            HStack(spacing: .medium) {
                Button("Turn on push notifications", style: .status(.info))
                Button(.close, style: .status(.info, subtle: true))
            }

            HStack(spacing: .medium) {
                Button("Icons", style: .secondary, icon: .anywhere, disclosureIcon: .chevronRight)
                Button("Icons", style: .secondary, icon: .accomodation, disclosureIcon: .informationCircle)
            }
        }
        .padding(.vertical)
        .previewDisplayName("Mix")
    }

    static var snapshots: some View {
        Group {
            orbit

            Button(
                "Custom",
                style: .critical,
                iconContent: .icon(.check, size: .large, color: .blueNormal)
            )
            .padding(.vertical)
            .previewDisplayName("Custom")
        }
        .frame(width: 350)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
    }
}

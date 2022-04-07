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
    let size: Size
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

                    Icon(iconContent, size: iconSize)

                    if #available(iOS 14.0, *) {
                        Text(
                            label,
                            size: size.textSize,
                            color: .custom(style.foregroundUIColor),
                            weight: .medium,
                            linkColor: style.foregroundUIColor
                        )
                    } else {
                        Text(
                            label,
                            size: size.textSize,
                            color: .custom(style.foregroundUIColor),
                            weight: .medium,
                            linkColor: style.foregroundUIColor
                        )
                        // Prevents text value animation issue due to different iOS13 behavior
                        .animation(nil)
                    }

                    Spacer(minLength: 0)

                    Icon(disclosureIconContent, size: iconSize)
                }
                .padding(.horizontal, label.isEmpty ? 0 : size.padding)
            }
        )
        .buttonStyle(ButtonStyle(style: style, size: size))
        .frame(minWidth: size.height, maxWidth: .infinity)
        .frame(width: isIconOnly ? size.height : nil)
    }

    var isIconOnly: Bool {
        iconContent.isEmpty == false && label.isEmpty
    }
    
    var iconSize: Icon.Size {
        size == .small ? .small : .large
    }

    func presentHapticFeedback() {
        switch style {
            case .primary:
                HapticsProvider.sendHapticFeedback(.light(1))
            case .primarySubtle, .secondary, .status(.info, _), .gradient:
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
        size: Size = .default,
        iconContent: Icon.Content = .none,
        disclosureIconContent: Icon.Content = .none,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.iconContent = iconContent
        self.disclosureIconContent = disclosureIconContent
        self.action = action
    }

    /// Creates Orbit Button component with icon symbol.
    init(
        _ label: String,
        style: Style = .primary,
        size: Size = .default,
        icon: Icon.Symbol = .none,
        disclosureIcon: Icon.Symbol = .none,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            size: size,
            iconContent: .icon(icon, color: style.foregroundColor),
            disclosureIconContent: .icon(disclosureIcon, color: style.foregroundColor),
            action: action
        )
    }
    
    /// Creates Orbit Button component with no icon.
    init(
        _ label: String,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            size: size,
            iconContent: .none,
            disclosureIconContent: .none,
            action: action
        )
    }

    /// Creates Orbit Button component with icon only.
    init(
        _ icon: Icon.Symbol = .none,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            "",
            style: style,
            size: size,
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
        case gradient(Gradient)

        var foregroundColor: Color {
            Color(foregroundUIColor)
        }

        var foregroundUIColor: UIColor {
            switch self {
                case .primary:                  return .white
                case .primarySubtle:            return .productDark
                case .secondary:                return .inkNormal
                case .critical:                 return .white
                case .criticalSubtle:           return .redDark
                case .status(.critical, false): return .white
                case .status(.critical, true):  return .redDarkHover
                case .status(.info, false):     return .white
                case .status(.info, true):      return .blueDarkHover
                case .status(.success, false):  return .white
                case .status(.success, true):   return .greenDarkHover
                case .status(.warning, false):  return .white
                case .status(.warning, true):   return .orangeDarkHover
                case .gradient:                 return .white
            }
        }

        @ViewBuilder public var background: some View {
            switch self {
                case .primary:                  Color.productNormal
                case .primarySubtle:            Color.productLight
                case .secondary:                Color.cloudDark
                case .critical:                 Color.redNormal
                case .criticalSubtle:           Color.redLight
                case .status(.critical, false): Color.redNormal
                case .status(.critical, true):  Color.redLightHover
                case .status(.info, false):     Color.blueNormal
                case .status(.info, true):      Color.blueLightHover
                case .status(.success, false):  Color.greenNormal
                case .status(.success, true):   Color.greenLightHover
                case .status(.warning, false):  Color.orangeNormal
                case .status(.warning, true):   Color.orangeLightHover
                case .gradient(let gradient):   gradient.background
            }
        }
        
        @ViewBuilder public var backgroundActive: some View {
            switch self {
                case .primary:                  Color.productNormalActive
                case .primarySubtle:            Color.productLightActive
                case .secondary:                Color.cloudNormalActive
                case .critical:                 Color.redNormalActive
                case .criticalSubtle:           Color.redLightActive
                case .status(.critical, false): Color.redNormalActive
                case .status(.critical, true):  Color.redLightActive
                case .status(.info, false):     Color.blueNormalActive
                case .status(.info, true):      Color.blueLightActive
                case .status(.success, false):  Color.greenNormalActive
                case .status(.success, true):   Color.greenLightActive
                case .status(.warning, false):  Color.orangeNormalActive
                case .status(.warning, true):   Color.orangeLightActive
                case .gradient(let gradient):   gradient.color
            }
        }
    }
    
    public enum Size {
        case `default`
        case small
        
        var height: CGFloat {
            switch self {
                case .default:      return Layout.preferredButtonHeight
                case .small:        return Layout.preferredSmallButtonHeight
            }
        }
        
        var textSize: Text.Size {
            switch self {
                case .default:      return .normal
                case .small:        return .small
            }
        }
        
        var padding: CGFloat {
            switch self {
                case .default:      return .small
                case .small:        return .xSmall
            }
        }
    }

    public struct ButtonStyle: SwiftUI.ButtonStyle {

        var style: Style
        var size: Size

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(height: size.height)
                .contentShape(Rectangle())
                .background(background(for: configuration))
                .cornerRadius(BorderRadius.default)
        }
        
        @ViewBuilder func background(for configuration: Configuration) -> some View {
            if configuration.isPressed {
                style.backgroundActive
            } else {
                style.background
            }
        }
    }

    public struct Content: ExpressibleByStringLiteral {
        let label: String
        let accessibilityIdentifier: String
        let action: () -> Void

        public init(_ label: String, accessibilityIdentifier: String = "", action: @escaping () -> Void = {}) {
            self.label = label
            self.accessibilityIdentifier = accessibilityIdentifier
            self.action = action
        }

        public init(stringLiteral value: String) {
            self.init(value)
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
            Button("Orange Gradient", style: .gradient(.bundleBasic), icon: .email)
            Button("Purple Gradient", style: .gradient(.bundleMedium), icon: .flightNomad, disclosureIcon: .chevronRight)
            Button("Ink Gradient", style: .gradient(.bundleTop), icon: .flightDirect, disclosureIcon: .chevronRight)

            HStack(spacing: .medium) {
                Button("Turn on push notifications", style: .gradient(.bundleMedium))
                Button(.close, style: .gradient(.bundleTop))
            }
        }
        .padding(.vertical)
        .previewDisplayName("Gradients")
        
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
                Button("Icons", style: .secondary, icon: .accommodation, disclosureIcon: .informationCircle)
            }
        }
        .padding(.vertical)
        .previewDisplayName("Mix")
        
        VStack(spacing: .medium) {
            Button("Secondary with icon", style: .secondary, size: .small, icon: .email)
            Button("Primary with Icons", style: .primary, size: .small, icon: .flightNomad, disclosureIcon: .chevronRight)
            Button("Secondary with Icons", style: .secondary, size: .small, icon: .flightDirect, disclosureIcon: .chevronRight)
            Button("Info with Icons", style: .status(.info), size: .small, icon: .flightDirect, disclosureIcon: .chevronRight)

            HStack(spacing: .medium) {
                Button("Turn on push notifications", style: .status(.info), size: .small)
                Button(.close, style: .status(.info, subtle: true), size: .small)
            }

            HStack(spacing: .medium) {
                Button("Icons", style: .secondary, size: .small, icon: .anywhere, disclosureIcon: .chevronRight)
                Button("Icons", style: .secondary, size: .small, icon: .accommodation, disclosureIcon: .informationCircle)
            }
        }
        .padding(.vertical)
        .previewDisplayName("Mix - small")
    }

    static var snapshots: some View {
        Group {
            orbit

            Button(
                "Custom",
                style: .critical,
                iconContent: .icon(.check, color: .blueNormal)
            )
            .padding(.vertical)
            .previewDisplayName("Custom")
        }
        .frame(width: 350)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
    }
}

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

        public var foregroundColor: Color {
            Color(foregroundUIColor)
        }

        public var foregroundUIColor: UIColor {
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
        
        public var height: CGFloat {
            switch self {
                case .default:      return Layout.preferredButtonHeight
                case .small:        return Layout.preferredSmallButtonHeight
            }
        }
        
        public var textSize: Text.Size {
            switch self {
                case .default:      return .normal
                case .small:        return .small
            }
        }
        
        public var padding: CGFloat {
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
        public let label: String
        public let accessibilityIdentifier: String
        public let action: () -> Void

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
            storybook
            storybookStatus
            storybookGradient
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Button("Button")
            .padding(.medium)
            .previewDisplayName("Standalone")
    }

    @ViewBuilder static var storybook: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .padding(.medium)
    }

    @ViewBuilder static var storybookStatus: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }
        .padding(.medium)
    }

    @ViewBuilder static var storybookGradient: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            buttons(.gradient(.bundleBasic)).previewDisplayName("Bundle Basic")
            buttons(.gradient(.bundleMedium)).previewDisplayName("Bundle Medium")
            buttons(.gradient(.bundleTop)).previewDisplayName("Bundle Top")
        }
        .padding(.medium)
    }

    @ViewBuilder static func buttons(_ style: Button.Style) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", style: style)
                Button("Label", style: style, icon: .grid)
            }
            HStack(spacing: .small) {
                Button("Label", style: style, disclosureIcon: .chevronRight)
                Button("Label", style: style, icon: .grid, disclosureIcon: .chevronRight)
            }
            HStack(spacing: .small) {
                Button("Label", style: style)
                    .fixedSize()
                Button(.grid, style: style)
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", style: style, size: .small)
                    .fixedSize()
                Button(.grid, style: style, size: .small)
                Spacer()
            }
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, subtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ style: Button.Style) -> some View {
        HStack(spacing: .xSmall) {
            Group {
                Button("Label", style: style, size: .small)
                Button("Label", style: style, size: .small, icon: .grid, disclosureIcon: .chevronRight)
                Button("Label", style: style, size: .small, disclosureIcon: .chevronRight)
                Button(.grid, style: style, size: .small)
            }
            .fixedSize()

            Spacer(minLength: 0)
        }
    }
}

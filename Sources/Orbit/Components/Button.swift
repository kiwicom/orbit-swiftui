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
    let iconContent: Icon.Content
    let disclosureIconContent: Icon.Content
    let style: Style
    let size: Size
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                presentHapticFeedback()
                action()
            },
            label: {
                HStack(spacing: 0) {
                    if disclosureIconContent.isEmpty {
                        Spacer(minLength: 0)
                    }

                    HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                        Icon(content: iconContent, size: iconSize)
                        text
                            .padding(.vertical, size.verticalPadding)
                    }

                    Spacer(minLength: 0)

                    TextStrut(size.textSize)
                        .padding(.vertical, size.verticalPadding)

                    Icon(content: disclosureIconContent, size: iconSize)
                }
                .padding(.leading, leadingPadding)
                .padding(.trailing, trailingPadding)
            }
        )
        .foregroundColor(Color(style.foregroundUIColor))
        .buttonStyle(ButtonStyle(style: style, size: size))
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder var text: some View {
        if #available(iOS 14.0, *) {
            Text(
                label,
                size: size.textSize,
                color: .none,
                weight: .medium,
                linkColor: .custom(style.foregroundUIColor)
            )
        } else {
            Text(
                label,
                size: size.textSize,
                color: .none,
                weight: .medium,
                linkColor: .custom(style.foregroundUIColor)
            )
            // Prevents text value animation issue due to different iOS13 behavior
            .animation(nil)
        }
    }

    var isIconOnly: Bool {
        iconContent.isEmpty == false && label.isEmpty
    }
    
    var iconSize: Icon.Size {
        size == .small ? .small : .normal
    }

    var leadingPadding: CGFloat {
        label.isEmpty == false && iconContent.isEmpty ? size.horizontalPadding : size.horizontalIconPadding
    }

    var trailingPadding: CGFloat {
        label.isEmpty == false && disclosureIconContent.isEmpty ? size.horizontalPadding : size.horizontalIconPadding
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
        icon: Icon.Content = .none,
        disclosureIcon: Icon.Content = .none,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.iconContent = icon
        self.disclosureIconContent = disclosureIcon
        self.style = style
        self.size = size
        self.action = action
    }

    /// Creates Orbit Button component with icon only.
    init(
        _ icon: Icon.Content = .none,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            "",
            icon: icon,
            disclosureIcon: .none,
            style: style,
            size: size,
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
                case .primary:                  return .whiteNormal
                case .primarySubtle:            return .productDark
                case .secondary:                return .inkNormal
                case .critical:                 return .whiteNormal
                case .criticalSubtle:           return .redDark
                case .status(.critical, false): return .whiteNormal
                case .status(.critical, true):  return .redDarkHover
                case .status(.info, false):     return .whiteNormal
                case .status(.info, true):      return .blueDarkHover
                case .status(.success, false):  return .whiteNormal
                case .status(.success, true):   return .greenDarkHover
                case .status(.warning, false):  return .whiteNormal
                case .status(.warning, true):   return .orangeDarkHover
                case .gradient:                 return .whiteNormal
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

        public var textSize: Text.Size {
            switch self {
                case .default:      return .normal
                case .small:        return .small
            }
        }
        
        public var horizontalPadding: CGFloat {
            switch self {
                case .default:      return .medium
                case .small:        return .small
            }
        }

        public var horizontalIconPadding: CGFloat {
            switch self {
                case .default:      return .small
                case .small:        return verticalPadding
            }
        }

        public var verticalPadding: CGFloat {
            switch self {
                case .default:      return .small + 1          // Makes height exactly 44 at normal text size
                case .small:        return .xSmall + 1/3       // Makes height exactly 32 at normal text size
            }
        }
    }

    public struct ButtonStyle: SwiftUI.ButtonStyle {

        var style: Style
        var size: Size

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
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
        public let action: () -> Void

        public init(_ label: String, action: @escaping () -> Void = {}) {
            self.label = label
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
            standaloneCombinations
            sizing

            storybook
            storybookStatus
            storybookGradient
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Button("Button", icon: .grid)
            .padding(.medium)
    }

    static var standaloneCombinations: some View {
        VStack(spacing: .medium) {
            Button("Button", icon: .grid)
            Button("Button", icon: .grid, disclosureIcon: .grid)
            Button("Button")
            Button(.grid)
            Button(.grid)
                .fixedSize()
            Button(.arrowUp)
                .fixedSize()
        }
        .padding(.medium)
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button height \(state.wrappedValue)")
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button height \(state.wrappedValue)", icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button small height \(state.wrappedValue)", size: .small)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button small height \(state.wrappedValue)", icon: .grid, size: .small)
                        .fixedSize()
                }
            }
        }
        .padding(.medium)
        .previewDisplayName("Sizing")
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

    @ViewBuilder static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button("Button with SF Symbol", icon: .sfSymbol("info.circle.fill"))
            Button("Button with Flag", icon: .countryFlag("cz"))
            Button("Button with Image", icon: .image(.orbit(.facebook)))
        }
        .padding(.medium)
    }

    @ViewBuilder static func buttons(_ style: Button.Style) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", style: style)
                Button("Label", icon: .grid, style: style)
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronRight, style: style)
                Button("Label", icon: .grid, disclosureIcon: .chevronRight, style: style)
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
                Button("Label", icon: .grid, disclosureIcon: .chevronRight, style: style, size: .small)
                Button("Label", disclosureIcon: .chevronRight, style: style, size: .small)
                Button(.grid, style: style, size: .small)
            }
            .fixedSize()

            Spacer(minLength: 0)
        }
    }
}

struct ButtonDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        ButtonPreviews.standaloneCombinations
        ButtonPreviews.sizing
        ButtonPreviews.buttons(.primary)
            .padding(.medium)
    }
}

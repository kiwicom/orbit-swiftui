import SwiftUI

/// Displays a single important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/button/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Button: View {

    @Environment(\.status) private var status
    @Environment(\.idealSize) private var idealSize

    let label: String
    let iconContent: Icon.Content
    let disclosureIconContent: Icon.Content
    let style: Style
    let size: Size
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(hapticFeedback)
                action()
            },
            label: {
                HStack(spacing: 0) {
                    TextStrut(size.textSize)

                    if disclosureIconContent.isEmpty, idealSize.horizontal == nil {
                        Spacer(minLength: 0)
                    }

                    HStack(spacing: .xSmall) {
                        Icon(content: iconContent, size: size.textSize.iconSize)
                            .foregroundColor(foregroundColor)
                        textWrapper
                    }

                    if idealSize.horizontal == nil {
                        Spacer(minLength: 0)
                    }

                    Icon(content: disclosureIconContent, size: size.textSize.iconSize)
                        .foregroundColor(foregroundColor)
                }
                .padding(.vertical, size.verticalPadding)
                .padding(.leading, leadingPadding)
                .padding(.trailing, trailingPadding)
            }
        )
        .buttonStyle(ButtonStyle(style: style, status: status, size: size))
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
    }

    @ViewBuilder var textWrapper: some View {
        if #available(iOS 14.0, *) {
            text
        } else {
            text
                // Prevents text value animation issue due to different iOS13 behavior
                .animation(nil)
        }
    }

    @ViewBuilder var text: some View {
        Text(label, size: size.textSize)
            .foregroundColor(foregroundColor)
            .fontWeight(.medium)
            .textLinkColor(.custom(foregroundColor))
    }

    public var foregroundColor: Color {
        switch style {
            case .primary:                      return .whiteNormal
            case .primarySubtle:                return .productDark
            case .secondary:                    return .inkDark
            case .critical:                     return .whiteNormal
            case .criticalSubtle:               return .redDark
            case .status(_, false):             return .whiteNormal
            case .status(let status, true):     return (status ?? defaultStatus).darkHoverColor
            case .gradient:                     return .whiteNormal
        }
    }

    var isIconOnly: Bool {
        iconContent.isEmpty == false && label.isEmpty
    }

    var leadingPadding: CGFloat {
        label.isEmpty == false && iconContent.isEmpty ? size.horizontalPadding : size.horizontalIconPadding
    }

    var trailingPadding: CGFloat {
        label.isEmpty == false && disclosureIconContent.isEmpty ? size.horizontalPadding : size.horizontalIconPadding
    }

    var defaultStatus: Status {
        status ?? .info
    }

    var resolvedStatus: Status {
        switch style {
            case .status(let status, _):    return status ?? defaultStatus
            default:                        return .info
        }
    }

    var hapticFeedback: HapticsProvider.HapticFeedbackType {
        switch style {
            case .primary:                                  return .light(1)
            case .primarySubtle, .secondary, .gradient:     return .light(0.5)
            case .critical, .criticalSubtle:                return .notification(.error)
            case .status:
                switch resolvedStatus {
                    case .info, .success:                   return .light(0.5)
                    case .warning:                          return .notification(.warning)
                    case .critical:                         return .notification(.error)
                }
        }
    }
}

// MARK: - Inits
public extension Button {

    /// Creates Orbit Button component.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ label: String,
        icon: Icon.Content = .none,
        disclosureIcon: Icon.Content = .none,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.iconContent = icon
        self.disclosureIconContent = disclosureIcon
        self.style = style
        self.size = size
        self.action = action
    }

    /// Creates Orbit Button component with icon only.
    ///
    /// - Parameters:
    ///   - style: A visual style of component. A `status` style can be optionally modified using `status()` modifier when `nil` value is provided.
    init(
        _ icon: Icon.Content,
        style: Style = .primary,
        size: Size = .default,
        action: @escaping () -> Void
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
        case status(Status?, isSubtle: Bool = false)
        case gradient(Gradient)
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
                case .default:      return .small   // = 44 height @ normal size
                case .small:        return .xSmall  // = 32 height @ normal size
            }
        }
    }

    public struct ButtonStyle: SwiftUI.ButtonStyle {

        var style: Style
        var status: Status?
        var size: Size

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .contentShape(Rectangle())
                .background(background(for: configuration))
                .cornerRadius(BorderRadius.default)
        }
        
        @ViewBuilder func background(for configuration: Configuration) -> some View {
            if configuration.isPressed {
                backgroundActive
            } else {
                background
            }
        }

        @ViewBuilder var background: some View {
            switch style {
                case .primary:                      Color.productNormal
                case .primarySubtle:                Color.productLight
                case .secondary:                    Color.cloudNormal
                case .critical:                     Color.redNormal
                case .criticalSubtle:               Color.redLight
                case .status(let status, false):    (status ?? defaultStatus).color
                case .status(let status, true):     (status ?? defaultStatus).lightHoverColor
                case .gradient(let gradient):       gradient.background
            }
        }

        @ViewBuilder var backgroundActive: some View {
            switch style {
                case .primary:                      Color.productNormalActive
                case .primarySubtle:                Color.productLightActive
                case .secondary:                    Color.cloudNormalActive
                case .critical:                     Color.redNormalActive
                case .criticalSubtle:               Color.redLightActive
                case .status(let status, false):    (status ?? defaultStatus).activeColor
                case .status(let status, true):     (status ?? defaultStatus).lightActiveColor
                case .gradient(let gradient):       gradient.foregroundColor
            }
        }

        var defaultStatus: Status {
            status ?? .info
        }
    }

    public struct Content: ExpressibleByStringLiteral {
        public let label: String
        public let action: () -> Void

        public init(_ label: String, action: @escaping () -> Void) {
            self.label = label
            self.action = action
        }

        public init(stringLiteral value: String) {
            self.init(value, action: {})
        }
    }
}

// MARK: - Previews
struct ButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            combinations
            sizing

            styles
            statuses
            gradients
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Button("Button", icon: .grid, action: {})
            .padding(.medium)
            .previewDisplayName()
    }

    static var combinations: some View {
        VStack(spacing: .medium) {
            Button("Button", icon: .grid, action: {})
            Button("Button", icon: .grid, disclosureIcon: .grid, action: {})
            Button("Button", action: {})
            Button(.grid, action: {})
            Button(.grid, action: {})
                .idealSize()
            Button(.arrowUp, action: {})
                .idealSize()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                Button("", action: {})
                Button("Button", action: {})
                Button("Button", icon: .grid, action: {})
                Button("Button\nmultiline", icon: .grid, action: {})
                Button(.grid, action: {})
                Button("Button small", size: .small, action: {})
                Button("Button small", icon: .grid, size: .small, action: {})
                Button(.grid, size: .small, action: {})
                Button("Button\nmultiline", size: .small, action: {})
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var styles: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var statuses: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var gradients: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.gradient(.bundleBasic)).previewDisplayName("Bundle Basic")
            buttons(.gradient(.bundleMedium)).previewDisplayName("Bundle Medium")
            buttons(.gradient(.bundleTop)).previewDisplayName("Bundle Top")
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button("Button with SF Symbol", icon: .sfSymbol("info.circle.fill"), action: {})
            Button("Button with Flag", icon: .countryFlag("cz"), action: {})
            Button("Button with Image", icon: .image(.orbit(.facebook)), action: {})
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .padding(.medium)
    }

    @ViewBuilder static func buttons(_ style: Button.Style) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", style: style, action: {})
                Button("Label", icon: .grid, style: style, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronForward, style: style, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, style: style, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", style: style, action: {})
                    .idealSize()
                Button(.grid, style: style, action: {})
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", style: style, size: .small, action: {})
                    .idealSize()
                Button(.grid, style: style, size: .small, action: {})
                Spacer()
            }
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, isSubtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ style: Button.Style) -> some View {
        HStack(spacing: .xSmall) {
            Group {
                Button("Label", style: style, size: .small, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, style: style, size: .small, action: {})
                Button("Label", disclosureIcon: .chevronForward, style: style, size: .small, action: {})
                Button(.grid, style: style, size: .small, action: {})
            }
            .idealSize()

            Spacer(minLength: 0)
        }
    }
}

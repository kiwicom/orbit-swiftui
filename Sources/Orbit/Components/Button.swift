import SwiftUI

/// Displays a single important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/button/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Button<LeadingIcon: View, TrailingIcon: View>: View {

    @Environment(\.suppressButtonStyle) private var suppressButtonStyle

    private let label: String
    private let type: ButtonType
    private let isTrailingIconSeparated: Bool
    private let action: () -> Void
    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let trailingIcon: TrailingIcon

    public var body: some View {
        if suppressButtonStyle {
            button
        } else {
            button
                .buttonStyle(
                    OrbitButtonStyle(type: type, isTrailingIconSeparated: isTrailingIconSeparated) {
                        leadingIcon
                    } trailingIcon: {
                        trailingIcon
                    }
                )
        }
    }

    @ViewBuilder var button: some View {
        SwiftUI.Button() {
            action()
        } label: {
            Text(label)
        }
    }
}

// MARK: - Inits
public extension Button {

    /// Creates Orbit Button component.
    ///
    /// Button size can be specified using `.buttonSize()` modifier.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A style can be optionally modified using `status()` modifier when `nil` status value is provided.
    init(
        _ label: String = "",
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        type: ButtonType = .primary,
        isTrailingIconSeparated: Bool = false,
        action: @escaping () -> Void
    ) where LeadingIcon == Icon, TrailingIcon == Icon {
        self.init(
            label,
            type: type,
            isTrailingIconSeparated: isTrailingIconSeparated
        ) {
            action()
        } icon: {
            Icon(icon)
        } disclosureIcon: {
            Icon(disclosureIcon)
        }
    }

    /// Creates Orbit Button component with custom icons.
    ///
    /// Button size can be specified using `.buttonSize()` modifier.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A style can be optionally modified using `status()` modifier when `nil` status value is provided.
    init(
        _ label: String = "",
        type: ButtonType = .primary,
        isTrailingIconSeparated: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> LeadingIcon,
        @ViewBuilder disclosureIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.label = label
        self.type = type
        self.isTrailingIconSeparated = isTrailingIconSeparated
        self.action = action
        self.leadingIcon = icon()
        self.trailingIcon = disclosureIcon()
    }
}

// MARK: - Types

public enum ButtonType {
    case primary
    case primarySubtle
    case secondary
    case critical
    case criticalSubtle
    case status(Status?, isSubtle: Bool = false)
    case gradient(Gradient)
}

/// Button style matching Orbit Button component.
public struct OrbitButtonStyle<LeadingIcon: View, TrailingIcon: View>: PrimitiveButtonStyle {

    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.status) private var status

    private var type: ButtonType
    private var isTrailingIconSeparated: Bool
    @ViewBuilder private let icon: LeadingIcon
    @ViewBuilder private let disclosureIcon: TrailingIcon

    public init(
        type: ButtonType,
        isTrailingIconSeparated: Bool = false,
        @ViewBuilder icon: () -> LeadingIcon,
        @ViewBuilder trailingIcon: () -> TrailingIcon
    ) {
        self.type = type
        self.isTrailingIconSeparated = isTrailingIconSeparated
        self.icon = icon()
        self.disclosureIcon = trailingIcon()
    }

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textColor: textColor,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            isTrailingIconSeparated: isTrailingIconSeparated,
            hapticFeedback: hapticFeedback
        ) {
            icon
        } disclosureIcon: {
            disclosureIcon
        } background: {
            background
        } backgroundActive: {
            backgroundActive
        }
        .textFontWeight(.medium)
        .textSize(textSize)
    }

    @ViewBuilder var background: some View {
        switch type {
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
        switch type {
            case .primary:                      Color.productNormalActive
            case .primarySubtle:                Color.productLightActive
            case .secondary:                    Color.cloudNormalActive
            case .critical:                     Color.redNormalActive
            case .criticalSubtle:               Color.redLightActive
            case .status(let status, false):    (status ?? defaultStatus).activeColor
            case .status(let status, true):     (status ?? defaultStatus).lightActiveColor
            case .gradient(let gradient):       gradient.textColor
        }
    }

    var defaultStatus: Status {
        status ?? .info
    }

    var textColor: Color {
        switch type {
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

    var resolvedStatus: Status {
        switch type {
            case .status(let status, _):    return status ?? self.status ?? .info
            default:                        return .info
        }
    }

    var hapticFeedback: HapticsProvider.HapticFeedbackType {
        switch type {
            case .primary:                                  return .light(1)
            case .primarySubtle, .secondary, .gradient:     return .light(0.5)
            case .critical, .criticalSubtle:                return .notification(.error)
            case .status:                                   return resolvedStatus.defaultHapticFeedback
        }
    }

    var textSize: Text.Size {
        switch buttonSize {
            case .default:      return .normal
            case .compact:      return .small
        }
    }

    var horizontalPadding: CGFloat {
        switch buttonSize {
            case .default:      return .medium
            case .compact:      return .small
        }
    }

    var verticalPadding: CGFloat {
        switch buttonSize {
            case .default:      return .small   // = 44 height @ normal size
            case .compact:      return .xSmall  // = 32 height @ normal size
        }
    }
}

public struct ButtonContent: ExpressibleByStringLiteral {

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
            Button(icon: .grid, action: {})
            Button(icon: .grid, action: {})
                .idealSize()
            Button(icon: .arrowUp, action: {})
                .idealSize()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                Button(action: {})
                Button("Button", action: {})
                Button("Button", icon: .grid, action: {})
                Button("Button\nmultiline", icon: .grid, action: {})
                Button(icon: .grid, action: {})
                Group {
                    Button("Button small", action: {})
                    Button("Button small", icon: .grid, action: {})
                    Button(icon: .grid, action: {})
                    Button("Button\nmultiline", action: {})
                }
                .buttonSize(.compact)
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
            Button("Button with SF Symbol") {
                // No action
            } icon: {
                Icon("info.circle.fill")
            }
            Button("Button with Flag", type: .secondary) {
                // No action
            } icon: {
                CountryFlag("us")
            }
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

    @ViewBuilder static func buttons(_ type: ButtonType) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                Button("Label", icon: .grid, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            .buttonSize(.compact)
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, isSubtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ type: ButtonType) -> some View {
        HStack(spacing: .xSmall) {
            Group {
                Button("Label", type: type, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
                Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
                Button(icon: .grid, type: type, action: {})
            }
            .buttonSize(.compact)

            Spacer(minLength: 0)
        }
    }
}

import SwiftUI

/// Orbit component that displays non-actionable, short and static information.
///
/// A ``Badge`` consists of a title and up to two icons.
///
/// ```swift
/// Badge("Label", icon: .grid, type: .lightInverted)
/// ```
///
/// ### Customizing appearance
///
/// The label and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
/// 
/// ```swift
/// Badge("Label", type: .status(nil))
///     .textColor(.inkNormal)
///     .iconColor(.redNormal)
///     .iconSize(.small)
/// ```
///
/// When type is set to ``BadgeType/status(_:inverted:)`` with a `nil` value, the default ``Status/info`` status can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// Badge("Label", type: .status(nil))
///     .status(.warning)
/// ```
///
/// ### Layout
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/badge/)
public struct Badge<LeadingIcon: View, Label: View, TrailingIcon: View>: View, PotentiallyEmptyView {

    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor

    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let label: Label
    @ViewBuilder private let trailingIcon: TrailingIcon
    @ViewBuilder private let type: BadgeType

    public var body: some View {
        if isEmpty == false {
            HStack(spacing: .xxSmall) {
                leadingIcon
                    .iconSize(.small)
                    .font(.system(size: Icon.Size.small.value))
                    .foregroundColor(resolvedLabelColor)

                label
                    .textFontWeight(.medium)
                    .textSize(.small)
                    .textLinkColor(.custom(resolvedLabelColor))
                    .frame(minWidth: minTextWidth)

                trailingIcon
                    .iconSize(.small)
                    .font(.system(size: Icon.Size.small.value))
                    .foregroundColor(resolvedLabelColor)
            }
            .textColor(resolvedLabelColor)
            .padding(.vertical, .xxSmall) // = 24 height @ normal size
            .padding(.horizontal, .xSmall)
            .background(
                resolvedBackground
                    .clipShape(Capsule())
            )
        }
    }

    @ViewBuilder private var resolvedBackground: some View {
        if let backgroundShape {
            backgroundShape.inactiveView
        } else {
            defaultBackgroundColor
        }
    }
    
    var isEmpty: Bool {
        leadingIcon.isEmpty && label.isEmpty && trailingIcon.isEmpty
    }
    
    private var resolvedLabelColor: Color {
        textColor ?? labelColor
    }
    
    private var labelColor: Color {
        switch type {
            case .light:                                return .inkDark
            case .lightInverted:                        return .whiteNormal
            case .neutral:                              return .inkDark
            case .status(let status, false):            return (status ?? defaultStatus).darkColor
            case .status(_, true):                      return .whiteNormal
        }
    }
    
    private var defaultBackgroundColor: Color {
        switch type {
            case .light:                                return .whiteDarker
            case .lightInverted:                        return .inkDark
            case .neutral:                              return .cloudLight
            case .status(let status, true):             return (status ?? defaultStatus).color
            case .status(let status, false):            return (status ?? defaultStatus).lightColor
        }
    }

    private var minTextWidth: CGFloat {
        Text.Size.small.lineHeight * sizeCategory.ratio - .xSmall
    }

    private var defaultStatus: Status {
        status ?? .info
    }
    
    /// Creates Orbit ``Badge`` component with custom content.
    public init(
        type: BadgeType = .neutral,
        @ViewBuilder label: () -> Label,
        @ViewBuilder icon: () -> LeadingIcon = { EmptyView() },
        @ViewBuilder trailingIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.type = type
        self.label = label()
        self.leadingIcon = icon()
        self.trailingIcon = trailingIcon()
    }
}

// MARK: - Convenience Inits
public extension Badge where Label == Text, LeadingIcon == Icon, TrailingIcon == Icon {
    
    /// Creates Orbit ``Badge`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        trailingIcon: Icon.Symbol? = nil,
        type: BadgeType = .neutral
    ) {
        self.init(type: type) {
            Text(label)
        } icon: {
            Icon(icon)
        } trailingIcon: {
            Icon(trailingIcon)
        }
    }
    
    /// Creates Orbit ``Badge`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        trailingIcon: Icon.Symbol? = nil,
        type: BadgeType = .neutral,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.init(type: type) {
            Text(label, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        } trailingIcon: {
            Icon(trailingIcon)
        }
    }
}

// MARK: - Types

/// A type of Orbit ``Badge`` and ``NotificationBadge``.
public enum BadgeType {

    case light
    case lightInverted
    case neutral
    case status(_ status: Status? = nil, inverted: Bool = false)

    /// An Orbit ``BadgeType`` `status` type with no value provided.
    public static var status: Self {
        .status(nil)
    }
}

// MARK: - Previews
struct BadgePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            styles
            gradients
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Badge("label", icon: .grid)
            
            // EmptyView
            Group {
                Badge()    
                Badge("")
                
                Badge {
                    Text("")
                } icon: {
                    Icon(nil)
                }
            }
            .border(.redNormal)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .trailing, spacing: .xSmall) {
            Group {
                Badge("Badge")
                Badge("Badge", icon: .grid)
                Badge("Badge", icon: .grid, trailingIcon: .grid)
                Badge(icon: .grid)
                Badge("Multiline\nBadge", icon: .grid)
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                badges(.light)
                badges(.lightInverted)
            }

            badges(.neutral)

            statusBadges(.info)
            statusBadges(.success)
            statusBadges(.warning)
            statusBadges(.critical)

            HStack(alignment: .top, spacing: .medium) {
                Badge("Very very very very very long badge")
                Badge("Very very very very very long badge")
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var gradients: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            gradientBadge(.bundleBasic)
            gradientBadge(.bundleMedium)
            gradientBadge(.bundleTop)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                Badge("Custom", icon: .airplane)
                    .iconColor(.pink)
                    .textColor(.blueDark)
                    .backgroundStyle(.whiteHover)

                Badge {
                    Text("Flag")
                } icon: {
                    CountryFlag("us")                    
                }
                
                Badge(type: .status(.critical, inverted: true)) {
                    Text("Flag")
                } icon: {
                    CountryFlag("cz")                    
                }
            }

            HStack(spacing: .small) {
                Badge(type: .status(.success)) {
                    Text("SF Symbol")
                } icon: {
                    Icon("info.circle.fill")                    
                }
                
                Badge(type: .status(.warning, inverted: true)) {
                    Text("SF Symbol")
                } icon: {
                    Image(systemName: "info.circle.fill")                    
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func badges(_ type: BadgeType) -> some View {
        HStack(spacing: .small) {
            Badge("label", type: type)
            Badge("label", icon: .grid, type: type)
            Badge(icon: .grid, type: type)
            Badge("label", trailingIcon: .grid, type: type)
            Badge("1", type: type)
        }
    }

    static func statusBadges(_ status: Status) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            badges(.status(status))
            badges(.status(status, inverted: true))
        }
        .previewDisplayName("\(String(describing: status).titleCased)")
    }

    static func gradientBadge(_ gradient: Gradient) -> some View {
        badges(.neutral)
            .textColor(.whiteNormal)
            .backgroundStyle(gradient.background)
            .previewDisplayName("\(String(describing: gradient).titleCased)")
    }
}

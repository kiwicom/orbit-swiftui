import SwiftUI

/// Displays a single, less important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/buttonlink/)
public struct ButtonLink: View {

    let label: String
    let style: Style
    let iconContent: Icon.Content
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
                    HStack(spacing: 0) {
                        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                            Icon(content: iconContent, size: iconSize)

                            Text(
                                label,
                                size: .normal,
                                color: nil,
                                weight: .medium,
                                accentColor: style.color.normal,
                                linkColor: .custom(style.color.normal)
                            )
                            .padding(.vertical, verticalPadding)
                        }

                        TextStrut(.normal)
                            .padding(.vertical, verticalPadding)
                    }
                }
            )
            .buttonStyle(OrbitStyle(style: style, size: size))
        }
    }
    
    var iconSize: Icon.Size {
        switch size {
            case .default:          return .normal
            case .button:           return .large
            case .buttonSmall:      return .small
        }
    }

    var verticalPadding: CGFloat {
        switch size {
            case .default:              return 0
            case .button:               return Button.Size.default.verticalPadding
            case .buttonSmall:          return .xSmall - 2
        }
    }
}

// MARK: - Inits
public extension ButtonLink {

    /// Creates Orbit ButtonLink component.
    init(
        _ label: String = "",
        style: Style = .primary,
        icon: Icon.Content = .none,
        size: Size = .default,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.style = style
        self.iconContent = icon
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
        case status(_ status: Status)
        case custom(colors: (normal: UIColor, active: UIColor))

        public var color: (normal: UIColor, active: UIColor) {
            switch self {
                case .primary:              return (.productNormal, .productLightActive)
                case .secondary:            return (.inkDark, .cloudDark)
                case .critical:             return (.redNormal, .redLightActive)
                case .status(.info):        return (.blueNormal, .blueLightActive)
                case .status(.success):     return (.greenNormal, .greenLightActive)
                case .status(.warning):     return (.orangeNormal, .orangeLightActive)
                case .status(.critical):    return (.redNormal, .redLightActive)
                case .custom(let colors):   return colors
            }
        }

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case
                    (.primary, .primary),
                    (.secondary, .secondary),
                    (.critical, .critical),
                    (.custom, .custom):
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

        let style: Style
        let size: ButtonLink.Size

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(Color(configuration.isPressed ? style.color.active : style.color.normal))
                .frame(maxWidth: size.maxWidth)
                .contentShape(Rectangle())
        }
    }
}

// MARK: - Previews
struct ButtonLinkPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            custom
            iconOnly
            countryFlag

            styles
            statuses
            sizes
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            ButtonLink("ButtonLink")
            ButtonLink("") // EmptyView
            ButtonLink()   // EmptyView
        }
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Group {
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink height \(state.wrappedValue)")
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink height \(state.wrappedValue)", icon: .grid)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink button height \(state.wrappedValue)", size: .button)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink button height \(state.wrappedValue)", icon: .grid, size: .button)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink small height \(state.wrappedValue)", size: .buttonSmall)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ButtonLink("ButtonLink small height \(state.wrappedValue)", icon: .grid, size: .buttonSmall)
                    }
                }
            }
            .border(Color.cloudNormal)
        }
        .previewDisplayName()
    }

    static var styles: some View {
        HStack(spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary)
                ButtonLink("ButtonLink Secondary", style: .secondary)
                ButtonLink("ButtonLink Critical", style: .critical)
            }
            VStack(alignment: .leading, spacing: .large) {
                ButtonLink("ButtonLink Primary", style: .primary, icon: .accommodation)
                ButtonLink("ButtonLink Secondary", style: .secondary, icon: .airplaneDown)
                ButtonLink("ButtonLink Critical", style: .critical, icon: .alertCircle)
            }
        }
        .previewDisplayName()
    }
    
    static var statuses: some View {
        VStack(alignment: .leading, spacing: .large) {
            ButtonLink("ButtonLink Info", style: .status(.info), icon: .informationCircle)
            ButtonLink("ButtonLink Success", style: .status(.success), icon: .checkCircle)
            ButtonLink("ButtonLink Warning", style: .status(.warning), icon: .alert)
            ButtonLink("ButtonLink Critical", style: .status(.critical), icon: .alertCircle)
        }
        .previewDisplayName()
    }
    
    static var sizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            ButtonLink("ButtonLink intrinsic size", icon: .baggageSet)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink small button size", icon: .baggageSet, size: .buttonSmall)
                .border(Color.cloudNormal)
            ButtonLink("ButtonLink button size", icon: .baggageSet, size: .button)
                .border(Color.cloudNormal)
        }
        .previewDisplayName()
    }

    @ViewBuilder static var custom: some View {
        ButtonLink(
            "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
            style: .custom(colors: (normal: .blueDark, active: .blueNormal)),
            icon: .kiwicom
        )
        .previewDisplayName()
    }

    @ViewBuilder static var iconOnly: some View {
        ButtonLink(icon: .kiwicom)
            .background(Color.blueLight)
            .padding(.vertical)
            .previewDisplayName()
    }

    @ViewBuilder static var countryFlag: some View {
        ButtonLink("Flag", icon: .countryFlag("us"))
            .padding(.vertical)
            .previewDisplayName()
    }

    static var snapshot: some View {
        styles
            .padding(.medium)
    }
}

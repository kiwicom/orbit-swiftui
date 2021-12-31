import SwiftUI

/// Displays a single, less important action a user can take.
///
/// - Related components:
///   - ``Button``
///   - ``TextLink``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/buttonlink/)
/// - Important: Component has the same height as a ``Button``, but does not expand horizontally.
public struct ButtonLink: View {

    let label: String
    let style: Style
    let iconContent: Icon.Content
    let alignment: VerticalAlignment
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                HStack(spacing: .xSmall) {
                    iconContent.view()
                    
                    Text(
                        label,
                        size: .normal,
                        color: nil,
                        weight: .medium,
                        accentColor: style.color.normal,
                        linkColor: style.color.normal
                    )
                }
            }
        )
        .buttonStyle(OrbitStyle(style: style, alignment: alignment))
    }
}

// MARK: - Inits
public extension ButtonLink {

    /// Creates Orbit ButtonLink component.
    init(
        _ label: String = "",
        style: Style = .primary,
        iconContent: Icon.Content = .none,
        alignment: VerticalAlignment = .center,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.style = style
        self.iconContent = iconContent
        self.alignment = alignment
        self.action = action
    }

    /// Creates Orbit ButtonLink component with icon symbol.
    init(
        _ label: String = "",
        style: Style = .primary,
        icon: Icon.Symbol = .none,
        alignment: VerticalAlignment = .center,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            iconContent: .icon(icon, size: .small),
            alignment: alignment,
            action: action
        )
    }
    
    /// Creates Orbit ButtonLink component with no icons.
    init(
        _ label: String = "",
        style: Style = .primary,
        alignment: VerticalAlignment = .center,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            label,
            style: style,
            iconContent: .none,
            alignment: alignment,
            action: action
        )
    }
}

// MARK: - Types
extension ButtonLink {

    public enum Style {
        case primary
        case secondary
        case critical
        case status(_ status: Status)
        case custom(colors: (normal: UIColor, active: UIColor))

        public var color: (normal: UIColor, active: UIColor) {
            switch self {
                case .primary:              return (.productNormal, .productLightActive)
                case .secondary:            return (.inkNormal, .cloudDarker)
                case .critical:             return (.redNormal, .redLightActive)
                case .status(.info):        return (.blueNormal, .blueLightActive)
                case .status(.success):     return (.greenNormal, .greenLightActive)
                case .status(.warning):     return (.orangeNormal, .orangeLightActive)
                case .status(.critical):    return (.redNormal, .redLightActive)
                case .custom(let colors):   return colors
            }
        }
    }

    private struct OrbitStyle: ButtonStyle {

        let style: Style
        let alignment: VerticalAlignment

        var frameAlignment: Alignment {
            switch alignment {
                case .bottom:               return .bottom
                case .top:                  return .top
                default:                    return .center
            }
        }

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(Color(configuration.isPressed ? style.color.active : style.color.normal))
                .frame(height: Layout.preferredButtonHeight, alignment: frameAlignment)
        }
    }
}

// MARK: - Previews
struct ButtonLinkPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
            snapshotsCustom
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ButtonLink("ButtonLink")
            
    }

    @ViewBuilder static var orbit: some View {
        VStack(alignment: .leading) {
            ButtonLink("Primary", style: .primary)
            ButtonLink("Secondary", style: .secondary)
            ButtonLink("Critical", style: .critical)
        }
        .padding(.vertical)
        .previewDisplayName("Styles")

        VStack(alignment: .leading) {
            ButtonLink("Primary", style: .primary, icon: .accomodation)
            ButtonLink("Secondary", style: .secondary, icon: .airplaneDown)
            ButtonLink("Critical", style: .critical, icon: .alertCircle)
        }
        .padding(.vertical)
        .previewDisplayName("With icon")

        VStack(alignment: .leading) {
            ButtonLink("Info", style: .status(.info), icon: .informationCircle)
            ButtonLink("Success", style: .status(.success), icon: .checkCircle)
            ButtonLink("Warning", style: .status(.warning), icon: .alert)
            ButtonLink("Critical", style: .status(.critical), icon: .alertCircle)
        }
        .padding(.vertical)
        .previewDisplayName("Status")
    }

    static var snapshots: some View {
        Group {
            orbit
        }
        .padding(.horizontal)
    }

    static var snapshotsCustom: some View {
        Group {
            ButtonLink(
                "Custom <u>formatted</u> <ref>ref</ref> <applink1>https://localhost</applink1>",
                style: .custom(colors: (normal: .blueDark, active: .blueNormal)),
                icon: .kiwicom
            )
            .previewDisplayName("Custom")

            ButtonLink(icon: .kiwicom)
                .background(Color.blueLight)
                .padding(.vertical)
                .previewDisplayName("No label")

            VStack(alignment: .leading, spacing: .small) {
                ButtonLink("Center", style: .secondary)
                    .background(Color.blueLight)

                ButtonLink("Top", style: .secondary, alignment: .top)
                    .background(Color.blueLight)

                ButtonLink("Bottom", style: .secondary, alignment: .bottom)
                    .background(Color.blueLight)
            }
            .padding(.vertical)
            .previewDisplayName("Alignments")
        }
        .padding(.horizontal)
    }
}

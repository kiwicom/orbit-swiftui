import SwiftUI

/// Customized button style for Orbit ``ButtonLink`` component.
public struct OrbitButtonLinkButtonStyle<LeadingIcon: View, TrailingIcon: View>: PrimitiveButtonStyle {

    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.idealSize) private var idealSize
    @Environment(\.status) private var status

    private let type: ButtonLinkType
    @ViewBuilder private let icon: LeadingIcon
    @ViewBuilder private let disclosureIcon: TrailingIcon

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textActiveColor: textActiveColor,
            horizontalPadding: horizontalPadding,
            horizontalLabelPadding: 0,
            verticalPadding: verticalPadding,
            horizontalBackgroundPadding: horizontalBackgroundPadding,
            verticalBackgroundPadding: verticalBackgroundPadding,
            spacing: .xSmall,
            hapticFeedback: hapticFeedback
        ) {
            icon
        } disclosureIcon: {
            disclosureIcon
        }
        .textFontWeight(.medium)
        .textColor(textColor)
        .backgroundStyle(.clear, active: backgroundActive)
        .buttonSize(resolvedButtonSize)
        .idealSize(horizontal: idealSizeHorizontal, vertical: idealSize.vertical)
    }

    var backgroundActive: Color {
        switch type {
            case .primary:                      return .productLightActive
            case .critical:                     return .redLightActive
            case .status(let status):           return (status ?? self.status)?.lightActiveColor ?? .productLightActive
        }
    }

    var resolvedButtonSize: ButtonSize {
        buttonSize ?? .regular
    }

    var idealSizeHorizontal: Bool? {
        idealSize.horizontal == false
            ? idealSize.horizontal
            : (resolvedButtonSize == .compact || idealSize.horizontal == true)
    }

    var textColor: Color {
        switch type {
            case .primary:                      return .productNormal
            case .critical:                     return .redNormal
            case .status(let status):           return (status ?? self.status)?.color ?? .productNormal
        }
    }

    var textActiveColor: Color {
        switch type {
            case .primary:                      return .productDarkActive
            case .critical:                     return .redDarkActive
            case .status(let status):           return (status ?? self.status)?.darkHoverColor ?? .productDarkActive
        }
    }

    var resolvedStatus: Status {
        switch type {
            case .status(let status):   return status ?? self.status ?? .info
            default:                    return .info
        }
    }

    var hapticFeedback: HapticsProvider.HapticFeedbackType {
        switch type {
            case .primary:  return .light(1)
            case .critical: return .notification(.error)
            case .status:   return resolvedStatus.defaultHapticFeedback
        }
    }

    var horizontalPadding: CGFloat {
        switch resolvedButtonSize {
            case .regular:  return .small
            case .compact:  return 0
        }
    }

    var verticalPadding: CGFloat {
        switch resolvedButtonSize {
            case .regular:  return .small   // = 44 height @ normal size
            case .compact:  return 6        // = 32 height @ normal size
        }
    }

    var horizontalBackgroundPadding: CGFloat {
        switch resolvedButtonSize {
            case .regular:  return 0
            case .compact:  return .xSmall
        }
    }

    var verticalBackgroundPadding: CGFloat {
        switch resolvedButtonSize {
            case .regular:  return 0
            case .compact:  return .xxxSmall
        }
    }
    
    /// Create button style for Orbit ``ButtonLink`` component.
    public init(
        type: ButtonLinkType = .primary,
        @ViewBuilder icon: () -> LeadingIcon = { EmptyView() },
        @ViewBuilder trailingIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.type = type
        self.icon = icon()
        self.disclosureIcon = trailingIcon()
    }
}

// MARK: - Previews
struct OrbitButtonLinkButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(OrbitButtonLinkButtonStyle())
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("OrbitButtonLinkButtonStyle")
        }
    }
}

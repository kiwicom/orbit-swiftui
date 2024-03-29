import SwiftUI

/// Button style for Orbit primary ``Button`` component.
/// 
/// The style can be further customized by using Orbit environment modifiers.
public struct OrbitButtonStyle<LeadingIcon: View, TrailingIcon: View>: PrimitiveButtonStyle {
    
    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor

    private var type: ButtonType
    @ViewBuilder private let icon: LeadingIcon
    @ViewBuilder private let disclosureIcon: TrailingIcon

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            horizontalPadding: padding,
            verticalPadding: padding,
            hapticFeedback: hapticFeedback
        ) {
            icon
        } disclosureIcon: {
            disclosureIcon
        }
        .textFontWeight(.medium)
        .textColor(textColor ?? labelColor)
        .textSize(textSize)
        .backgroundStyle(backgroundShape?.inactive ?? background, active: backgroundShape?.active ?? backgroundActive)
    }
    
    private var background: Color {
        switch type {
            case .primary:                      return .productNormal
            case .primarySubtle:                return .productLight
            case .secondary:                    return .cloudNormal
            case .critical:                     return .redNormal
            case .criticalSubtle:               return .redLight
            case .status(let status, false):    return (status ?? self.status)?.color ?? .productNormal
            case .status(let status, true):     return (status ?? self.status)?.lightHoverColor ?? .productLight
        }
    }

    private var backgroundActive: Color {
        switch type {
            case .primary:                      return .productNormalActive
            case .primarySubtle:                return .productLightActive
            case .secondary:                    return .cloudNormalActive
            case .critical:                     return .redNormalActive
            case .criticalSubtle:               return .redLightActive
            case .status(let status, false):    return (status ?? self.status)?.activeColor ?? .productNormalActive
            case .status(let status, true):     return (status ?? self.status)?.lightActiveColor ?? .productLightActive
        }
    }

    private var labelColor: Color {
        switch type {
            case .primary:                      return .whiteNormal
            case .primarySubtle:                return .productDark
            case .secondary:                    return .inkDark
            case .critical:                     return .whiteNormal
            case .criticalSubtle:               return .redDark
            case .status(_, false):             return .whiteNormal
            case .status(let status, true):     return (status ?? self.status)?.darkHoverColor ?? .whiteNormal
        }
    }

    private var resolvedStatus: Status {
        switch type {
            case .status(let status, _):    return status ?? self.status ?? .info
            default:                        return .info
        }
    }

    private var resolvedButtonSize: ButtonSize {
        buttonSize ?? .regular
    }

    private var hapticFeedback: HapticsProvider.HapticFeedbackType {
        switch type {
            case .primary:                                  return .light(1)
            case .primarySubtle, .secondary:                return .light(0.5)
            case .critical, .criticalSubtle:                return .notification(.error)
            case .status:                                   return resolvedStatus.defaultHapticFeedback
        }
    }

    private var textSize: Text.Size {
        switch resolvedButtonSize {
            case .regular:      return .normal
            case .compact:      return .small
        }
    }

    private var padding: CGFloat {
        switch resolvedButtonSize {
            case .regular:      return .small   // = 44 height @ normal size
            case .compact:      return .xSmall  // = 32 height @ normal size
        }
    }
    
    /// Create button style for Orbit ``Button`` component.
    public init(
        type: ButtonType = .primary,
        @ViewBuilder icon: () -> LeadingIcon = { EmptyView() },
        @ViewBuilder trailingIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.type = type
        self.icon = icon()
        self.disclosureIcon = trailingIcon()
    }
}


// MARK: - Previews
struct OrbitButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(OrbitButtonStyle(type: .primary))
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("OrbitButtonStyle")
        }
    }
}

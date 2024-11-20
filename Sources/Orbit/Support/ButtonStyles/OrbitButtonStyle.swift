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
            case .primary:                      .productNormal
            case .primarySubtle:                .productLight
            case .secondary:                    .cloudNormal
            case .critical:                     .redNormal
            case .criticalSubtle:               .redLight
            case .prominent:                    .inkDark
            case .status(let status, false):    (status ?? self.status)?.color ?? .productNormal
            case .status(let status, true):     (status ?? self.status)?.lightHoverColor ?? .productLight
        }
    }

    private var backgroundActive: Color {
        switch type {
            case .primary:                      .productNormalActive
            case .primarySubtle:                .productLightActive
            case .secondary:                    .cloudNormalActive
            case .critical:                     .redNormalActive
            case .criticalSubtle:               .redLightActive
            case .prominent:                    .inkDarkActive
            case .status(let status, false):    (status ?? self.status)?.activeColor ?? .productNormalActive
            case .status(let status, true):     (status ?? self.status)?.lightActiveColor ?? .productLightActive
        }
    }

    private var labelColor: Color {
        switch type {
            case .primary:                      .whiteNormal
            case .primarySubtle:                .productDark
            case .secondary:                    .inkDark
            case .critical:                     .whiteNormal
            case .criticalSubtle:               .redDark
            case .prominent:                    .whiteNormal
            case .status(_, false):             .whiteNormal
            case .status(let status, true):     (status ?? self.status)?.darkHoverColor ?? .whiteNormal
        }
    }

    private var resolvedStatus: Status {
        switch type {
            case .status(let status, _):        status ?? self.status ?? .info
            default:                            .info
        }
    }

    private var resolvedButtonSize: ButtonSize {
        buttonSize ?? .regular
    }

    private var hapticFeedback: HapticsProvider.HapticFeedbackType {
        switch type {
            case .primary, .prominent:          .light(1)
            case .primarySubtle, .secondary:    .light(0.5)
            case .critical, .criticalSubtle:    .notification(.error)
            case .status:                       resolvedStatus.defaultHapticFeedback
        }
    }

    private var textSize: Text.Size {
        switch resolvedButtonSize {
            case .regular:                      .normal
            case .compact:                      .small
        }
    }

    private var padding: CGFloat {
        switch resolvedButtonSize {
            case .regular:                      .small   // = 44 height @ normal size
            case .compact:                      .xSmall  // = 32 height @ normal size
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

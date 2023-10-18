import SwiftUI

/// Customized button style for Orbit ``Button`` component.
public struct OrbitCustomButtonStyle<LeadingIcon: View, TrailingIcon: View>: PrimitiveButtonStyle {

    var textActiveColor: Color? = nil
    var horizontalPadding: CGFloat = .medium
    var horizontalLabelPadding: CGFloat = .xxSmall
    var verticalPadding: CGFloat = .small
    var horizontalBackgroundPadding: CGFloat = 0
    var verticalBackgroundPadding: CGFloat = 0
    var cornerRadius: CGFloat = BorderRadius.default
    var spacing: CGFloat = .xxSmall
    var isTrailingIconSeparated = false
    var hapticFeedback: HapticsProvider.HapticFeedbackType = .light()
    @ViewBuilder let icon: LeadingIcon
    @ViewBuilder let disclosureIcon: TrailingIcon

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textActiveColor: textActiveColor,
            horizontalPadding: horizontalPadding,
            horizontalLabelPadding: horizontalLabelPadding,
            verticalPadding: verticalPadding,
            horizontalBackgroundPadding: horizontalBackgroundPadding,
            verticalBackgroundPadding: verticalBackgroundPadding,
            cornerRadius: cornerRadius,
            spacing: spacing,
            isTrailingIconSeparated: isTrailingIconSeparated,
            hapticFeedback: hapticFeedback
        ) {
            icon
        } disclosureIcon: {
            disclosureIcon
        }
    }
}

// MARK: - Previews
struct OrbitCustomButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(
                    OrbitCustomButtonStyle() {
                        EmptyView()
                    } disclosureIcon: {
                        Icon(.chevronForward)
                    }
                )
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

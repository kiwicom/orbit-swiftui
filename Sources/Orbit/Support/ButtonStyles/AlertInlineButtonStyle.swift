import SwiftUI

struct AlertInlineButtonStyle: PrimitiveButtonStyle {

    @Environment(\.status) private var status

    func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textActiveColor: resolvedStatus.darkHoverColor,
            horizontalPadding: 0,
            horizontalLabelPadding: 0,
            verticalPadding: 6, // = 32 height @ normal size
            horizontalBackgroundPadding: .xSmall,
            verticalBackgroundPadding: .xxxSmall,
            spacing: .xSmall,
            hapticFeedback: resolvedStatus.defaultHapticFeedback
        ) {
            EmptyView()
        } disclosureIcon: {
            EmptyView()
        }
        .textFontWeight(.medium)
        .textColor(resolvedStatus.darkColor)
        .backgroundColor(.clear, active: resolvedStatus.color.opacity(0.24))
        .idealSize()
    }

    var resolvedStatus: Status {
        status ?? .info
    }
}

// MARK: - Previews
struct AlertInlineButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(AlertInlineButtonStyle())
        }
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("AlertInlineButtonStyle")
        }
    }
}

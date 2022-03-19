import SwiftUI

/// Orbit message below form fields.
public struct FormFieldMessage: View {

    let message: MessageType
    let spacing: CGFloat

    public var body: some View {
        if message.isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: spacing) {
                Icon(message.icon, size: .small, color: message.color)
                Text(message.description, color: .custom(message.uiColor))
                    .alignmentGuide(.firstTextBaseline) { _ in
                        Text.Size.normal.value * 1.2
                    }
            }
            .padding(.top, .xxSmall)
            .transition(.opacity.animation(.easeOut(duration: 0.2)))
        }
    }

    public init(_ message: MessageType, spacing: CGFloat = 5) {
        self.message = message
        self.spacing = spacing
    }
}

// MARK: - Previews
struct FormFieldMessagePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FormFieldMessage(.normal("Form Field Message", icon: .informationCircle))
            FormFieldMessage(.error("Form Field Message", icon: .alertCircle))
        }
        .previewLayout(.sizeThatFits)
    }
}

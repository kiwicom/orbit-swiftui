import SwiftUI

/// Orbit message below form fields.
public struct FormFieldMessage: View {

    @Environment(\.sizeCategory) var sizeCategory

    let message: MessageType
    let spacing: CGFloat

    public var body: some View {
        if message.isEmpty == false {
            // A Label should be used instead when Orbit fixes the non-matching icon to label sizing
            HStack(alignment: .firstTextBaseline, spacing: spacing) {
                Icon(message.icon, size: .small, color: message.color)
                    .accessibility(.fieldMessageIcon)
                    .alignmentGuide(.firstTextBaseline) { _ in
                        Icon.Size.small.value * sizeCategory.ratio * 0.82 - 2 * (sizeCategory.ratio - 1)
                    }
                Text(message.description, color: .custom(message.uiColor))
                    .accessibility(.fieldMessage)
            }
            .transition(.opacity.animation(.easeOut(duration: 0.2)))
        }
    }

    public init(_ message: MessageType, spacing: CGFloat = .xxSmall) {
        self.message = message
        self.spacing = spacing
    }
}

// MARK: - Previews
struct FormFieldMessagePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FormFieldMessage(.normal("Form Field Message", icon: .informationCircle))
            FormFieldMessage(.help("Help Message"))
            FormFieldMessage(.error("Form Field Message", icon: .alertCircle))
        }
        .previewLayout(.sizeThatFits)
    }
}

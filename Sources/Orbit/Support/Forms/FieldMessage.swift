import SwiftUI

/// Orbit message below form fields.
public struct FieldMessage: View {

    @Environment(\.sizeCategory) var sizeCategory

    let message: Message?
    let spacing: CGFloat

    public var body: some View {
        if let message = message, message.isEmpty == false {
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

    public init(_ message: Message?, spacing: CGFloat = .xxSmall) {
        self.message = message
        self.spacing = spacing
    }
}

// MARK: - Previews
struct FieldMessagePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FieldMessage(nil)
            FieldMessage(.normal("Form Field Message", icon: .informationCircle))
            FieldMessage(.help("Help Message"))
            FieldMessage(.error("Form Field Message", icon: .alertCircle))
        }
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI

/// Orbit message below form fields.
public struct FieldMessage: View {

    @Environment(\.sizeCategory) var sizeCategory

    let message: Message?
    let spacing: CGFloat

    public var body: some View {
        if let message = message, message.isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: spacing) {
                Icon(message.icon, size: .small, color: message.color)
                    .accessibility(.fieldMessageIcon)
                    // A workaround for current Orbit non-matching icon size
                    .alignmentGuide(.firstTextBaseline) { $0.height * 0.82 }
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

// MARK: - Identifiers
public extension AccessibilityID {

    static let fieldMessage         = Self(rawValue: "orbit.field.message")
    static let fieldMessageIcon     = Self(rawValue: "orbit.field.message.icon")
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
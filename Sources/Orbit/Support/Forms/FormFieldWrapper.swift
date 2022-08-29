import SwiftUI

/// Orbit wrapper around form fields. Provides optional label and message.
public struct FormFieldWrapper<Content: View, MessageContent: View>: View {

    @Binding private var messageHeight: CGFloat

    let label: String
    var accentColor: UIColor? = nil
    var linkColor: TextLink.Color = .primary
    var linkAction: TextLink.Action = { _, _ in }
    let message: MessageType
    @ViewBuilder let content: Content
    @ViewBuilder let messageContent: MessageContent

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FormFieldLabel(label, accentColor: accentColor, linkColor: linkColor, linkAction: linkAction)
                .padding(.bottom, .xxSmall)

            content

            ContentHeightReader(height: $messageHeight) {
                VStack(alignment: .leading, spacing: 0) {
                    messageContent

                    FormFieldMessage(message)
                        .padding(.top, .xxSmall)
                }
                .animation(.easeOut(duration: 0.2), value: message)
            }
        }
    }

    /// Creates Orbit wrapper around form field content including an additional custom message content.
    public init(
        _ label: String,
        accentColor: UIColor? = nil,
        linkColor: TextLink.Color = .primary,
        linkAction: @escaping TextLink.Action = { _, _ in },
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder messageContent: () -> MessageContent
    ) {
        self.label = label
        self.accentColor = accentColor
        self.linkColor = linkColor
        self.linkAction = linkAction
        self.message = message
        self._messageHeight = messageHeight
        self.content = content()
        self.messageContent = messageContent()
    }

    /// Creates Orbit wrapper around form field content.
    public init(
        _ label: String,
        accentColor: UIColor? = nil,
        linkColor: TextLink.Color = .primary,
        linkAction: @escaping TextLink.Action = { _, _ in },
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content
    ) where MessageContent == EmptyView {
        self.init(
            label,
            accentColor: accentColor,
            linkColor: linkColor,
            linkAction: linkAction,
            message: message,
            messageHeight: messageHeight,
            content: content
        ) {
            EmptyView()
        }
    }
}

// MARK: - Previews
struct FormFieldWrapperPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FormFieldWrapper("Form Field Label", message: .help("Help message")) {
                contentPlaceholder
            }

            FormFieldWrapper("Form Field Label") {
                contentPlaceholder
            }

            FormFieldWrapper(
                "Form Field Label with <ref>accent</ref> and <applink1>TextLink</applink1>",
                accentColor: .orangeNormal,
                linkColor: .status(.info)
            ) {
                contentPlaceholder
            }

            FormFieldWrapper("", message: .none) {
                contentPlaceholder
            }

            StateWrapper(initialState: (true, true, CGFloat(0), false)) { state in
                VStack(alignment: .leading, spacing: .large) {
                    FormFieldWrapper(
                        state.0.wrappedValue ? "Form Field Label" : "",
                        message: state.1.wrappedValue ? .error("Error message") : .none,
                        messageHeight: state.2
                    ) {
                        contentPlaceholder
                    }

                    Text("Message height: \(state.2.wrappedValue)")

                    HStack(spacing: .medium) {
                        Button("Toggle label") {
                            state.0.wrappedValue.toggle()
                            state.3.wrappedValue.toggle()
                        }
                        Button("Toggle message") {
                            state.1.wrappedValue.toggle()
                            state.3.wrappedValue.toggle()
                        }
                    }
                    
                    Spacer()
                }
                .animation(.easeOut(duration: 1), value: state.3.wrappedValue)
            }
            .previewDisplayName("Live preview")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI

/// Orbit wrapper around form fields. Provides optional label and message.
public struct FormFieldWrapper<Content: View, MessageContent: View>: View {

    @Binding private var messageHeight: CGFloat

    let label: String
    let message: MessageType
    let content: () -> Content
    let messageContent: () -> MessageContent

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FormFieldLabel(label)
                .padding(.bottom, .xxSmall)

            content()

            ContentHeightReader(height: $messageHeight.animation(.easeOut(duration: 0.2))) {
                VStack(alignment: .leading, spacing: 0) {
                    messageContent()

                    FormFieldMessage(message)
                        .padding(.top, .xxSmall)
                }
            }
        }
    }

    /// Creates Orbit wrapper around form field content including an additional custom message content.
    public init(
        _ label: String,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder messageContent: @escaping () -> MessageContent
    ) {
        self.label = label
        self.message = message
        self._messageHeight = messageHeight
        self.content = content
        self.messageContent = messageContent
    }

    /// Creates Orbit wrapper around form field content.
    public init(
        _ label: String,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: @escaping () -> Content
    ) where MessageContent == EmptyView {
        self.label = label
        self.message = message
        self._messageHeight = messageHeight
        self.content = content
        self.messageContent = { EmptyView() }
    }
}

// MARK: - Previews
struct FormFieldWrapperPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FormFieldWrapper("Form Field Label", message: .help("Help message")) {
                customContentPlaceholder
            }

            FormFieldWrapper("Form Field Label", message: .none) {
                customContentPlaceholder
            }

            FormFieldWrapper("", message: .none) {
                customContentPlaceholder
            }

            StateWrapper(initialState: (true, true, 0)) { state in
                VStack(alignment: .leading, spacing: .large) {
                    FormFieldWrapper(
                        state.wrappedValue.0 ? "Form Field Label" : "",
                        message: state.wrappedValue.1 ? .error("Error message") : .none,
                        messageHeight: .init(get: { state.wrappedValue.2 }, set: { state.wrappedValue.2 = $0 })
                    ) {
                        customContentPlaceholder
                    }

                    Text("Message height: \(state.wrappedValue.2)")

                    HStack(spacing: .medium) {
                        Button("Toggle label") {
                            state.wrappedValue.0.toggle()
                        }
                        Button("Toggle message") {
                            state.wrappedValue.1.toggle()
                        }
                    }
                }
                .animation(.default, value: state.wrappedValue.1)
            }
            .previewDisplayName("Live preview")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}

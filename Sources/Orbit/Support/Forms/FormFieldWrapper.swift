import SwiftUI

/// Orbit wrapper around form fields. Provides optional label and message.
public struct FormFieldWrapper<LabelContent: View, Content: View, MessageContent: View>: View {

    @Binding private var messageHeight: CGFloat

    let message: MessageType
    @ViewBuilder let content: Content
    @ViewBuilder let labelContent: LabelContent
    @ViewBuilder let messageContent: MessageContent

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            labelContent
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
}

// MARK: - Inits
public extension FormFieldWrapper {

    /// Creates Orbit wrapper around form field content with a custom label and an additional message content.
    ///
    /// `FormFieldLabel` is a default component for constructing custom label.
    init(
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder labelContent: () -> LabelContent,
        @ViewBuilder messageContent: () -> MessageContent
    ) {
        self.message = message
        self._messageHeight = messageHeight
        self.content = content()
        self.labelContent = labelContent()
        self.messageContent = messageContent()
    }
}

public extension FormFieldWrapper where MessageContent == EmptyView {

    /// Creates Orbit wrapper around form field content with a custom label.
    ///
    /// `FormFieldLabel` is a default component for constructing custom label.
    init(
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder labelContent: () -> LabelContent
    ) {
        self.init(
            message: message,
            messageHeight: messageHeight,
            content: content,
            labelContent: labelContent,
            messageContent: {
                EmptyView()
            }
        )
    }
}

public extension FormFieldWrapper where LabelContent == FormFieldLabel {

    /// Creates Orbit wrapper around form field content with an additional message content.
    init(
        _ label: String,
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder messageContent: () -> MessageContent
    ) {
        self.init(
            message: message,
            messageHeight: messageHeight,
            content: content,
            labelContent: {
                FormFieldLabel(label, accentColor: labelAccentColor, linkColor: labelLinkColor, linkAction: labelLinkAction)
            },
            messageContent: messageContent
        )
    }
}

public extension FormFieldWrapper where LabelContent == FormFieldLabel, MessageContent == EmptyView {

    /// Creates Orbit wrapper around form field content.
    init(
        _ label: String,
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            label,
            labelAccentColor: labelAccentColor,
            labelLinkColor: labelLinkColor,
            labelLinkAction: labelLinkAction,
            message: message,
            messageHeight: messageHeight,
            content: content,
            messageContent: {
                EmptyView()
            }
        )
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

            FormFieldWrapper {
                contentPlaceholder
            } labelContent: {
                FormFieldLabel("Form Field Label with <ref>accent</ref> and <applink1>TextLink</applink1>", accentColor: .orangeNormal, linkColor: .status(.info))
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

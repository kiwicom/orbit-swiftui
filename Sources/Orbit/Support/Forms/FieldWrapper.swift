import SwiftUI

/// Orbit wrapper around form fields. Provides optional label and message.
public struct FieldWrapper<Label: View, Content: View, Footer: View>: View {

    @Binding private var messageHeight: CGFloat

    @ViewBuilder let label: Label
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer
    let message: Message?

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            label
                .padding(.bottom, .xxSmall)

            content

            ContentHeightReader(height: $messageHeight) {
                VStack(alignment: .leading, spacing: 0) {
                    footer

                    FieldMessage(message)
                        .padding(.top, .xxSmall)
                }
                .animation(.easeOut(duration: 0.2), value: message)
            }
        }
    }
}

// MARK: - Inits
public extension FieldWrapper {

    /// Creates Orbit wrapper around form field content with a custom label and an additional message content.
    ///
    /// `FieldLabel` is a default component for constructing custom label.
    init(
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label,
        @ViewBuilder footer: () -> Footer
    ) {
        self.message = message
        self._messageHeight = messageHeight
        self.content = content()
        self.label = label()
        self.footer = footer()
    }
}

public extension FieldWrapper where Footer == EmptyView {

    /// Creates Orbit wrapper around form field content with a custom label.
    ///
    /// `FieldLabel` is a default component for constructing custom label.
    init(
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.init(
            message: message,
            messageHeight: messageHeight,
            content: content,
            label: label,
            footer: {
                EmptyView()
            }
        )
    }
}

public extension FieldWrapper where Label == FieldLabel {

    /// Creates Orbit wrapper around form field content with an additional message content.
    init(
        _ label: String,
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            message: message,
            messageHeight: messageHeight,
            content: content,
            label: {
                FieldLabel(label, accentColor: labelAccentColor, linkColor: labelLinkColor, linkAction: labelLinkAction)
            },
            footer: footer
        )
    }
}

public extension FieldWrapper where Label == FieldLabel, Footer == EmptyView {

    /// Creates Orbit wrapper around form field content.
    init(
        _ label: String,
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        message: Message? = nil,
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
            footer: {
                EmptyView()
            }
        )
    }
}

// MARK: - Previews
struct FieldWrapperPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FieldWrapper("Form Field Label", message: .help("Help message")) {
                contentPlaceholder
            }

            FieldWrapper("Form Field Label") {
                contentPlaceholder
            }

            FieldWrapper {
                contentPlaceholder
            } label: {
                FieldLabel("Form Field Label with <ref>accent</ref> and <applink1>TextLink</applink1>", accentColor: .orangeNormal, linkColor: .status(.info))
            }

            FieldWrapper("", message: .none) {
                contentPlaceholder
            }

            StateWrapper(initialState: (true, true, CGFloat(0), false)) { state in
                VStack(alignment: .leading, spacing: .large) {
                    FieldWrapper(
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

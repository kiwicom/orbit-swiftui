import SwiftUI

/// Orbit support component that orovides label and message around input field.
public struct FieldWrapper<Label: View, Content: View, Footer: View>: View {

    @Binding private var messageHeight: CGFloat

    private let message: Message?
    @ViewBuilder private let content: Content
    @ViewBuilder private let label: Label
    @ViewBuilder private let footer: Footer

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            label
                .textFontWeight(.medium)
                // Component should expose label as part of content
                .accessibility(hidden: true)
                .accessibility(removeTraits: .isStaticText)
                .padding(.bottom, .xxSmall)

            content

            ContentHeightReader(height: $messageHeight) {
                VStack(alignment: .leading, spacing: 0) {
                    footer

                    FieldMessage(message)
                        .padding(.top, .xxSmall)
                }
            }
        }
    }
    
    /// Creates Orbit ``FieldWrapper`` around form field content with a custom label and an additional message content.
    public init(
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.message = message
        self._messageHeight = messageHeight
        self.content = content()
        self.label = label()
        self.footer = footer()
    }
}

// MARK: - Convenience Inits
public extension FieldWrapper where Label == Text {

    /// Creates Orbit ``FieldWrapper`` around form field content with an additional message content.
    init(
        _ label: String,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.init(
            message: message,
            messageHeight: messageHeight,
            content: content,
            label: {
                Text(label)
            },
            footer: footer
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
                Text("Form Field Label with <ref>accent</ref> and <applink1>TextLink</applink1>")
                    .textLinkColor(.status(.info))
                    .textAccentColor(.orangeNormal)
            }

            FieldWrapper("", message: .none) {
                contentPlaceholder
            }

            StateWrapper((true, true, CGFloat(0), false)) { state in
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

import SwiftUI

/// Orbit support component that provides label and message around the form field.
public struct FieldWrapper<Label: View, Content: View, Footer: View>: View {

    private let message: Message?
    @ViewBuilder private let label: Label
    @ViewBuilder private let footer: Footer
    @ViewBuilder private let content: Content

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            label
                .textFontWeight(.medium)
                .padding(.bottom, .xxSmall)

            content

            VStack(alignment: .leading, spacing: 0) {
                footer

                FieldMessage(message)
                    .padding(.top, .xxSmall)
            }
        }
    }
    
    /// Creates Orbit ``FieldWrapper`` around form field content with a custom label and an additional message content.
    public init(
        message: Message? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.message = message
        self.content = content()
        self.label = label()
        self.footer = footer()
    }
}

// MARK: - Convenience Inits
public extension FieldWrapper where Label == Text {

    /// Creates Orbit ``FieldWrapper`` around form field content with an additional message content.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        message: Message? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.init(
            message: message,
            content: content,
            label: {
                Text(label)
            },
            footer: footer
        )
    }
    
    /// Creates Orbit ``FieldWrapper`` around form field content with an additional message content.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey = "",
        message: Message? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.init(
            message: message,
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

            StateWrapper((true, true, false)) { state in
                VStack(alignment: .leading, spacing: .large) {
                    FieldWrapper(
                        state.0.wrappedValue ? "Form Field Label" : "",
                        message: state.1.wrappedValue ? .error("Error message") : .none
                    ) {
                        contentPlaceholder
                    }

                    HStack(spacing: .medium) {
                        Button("Toggle label") {
                            state.0.wrappedValue.toggle()
                            state.2.wrappedValue.toggle()
                        }
                        Button("Toggle message") {
                            state.1.wrappedValue.toggle()
                            state.2.wrappedValue.toggle()
                        }
                    }
                    
                    Spacer()
                }
                .animation(.easeOut(duration: 1), value: state.2.wrappedValue)
            }
            .previewDisplayName("Live preview")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}

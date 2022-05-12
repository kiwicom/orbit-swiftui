import SwiftUI

/// Orbit wrapper around form fields. Provides optional label and message.
public struct FormFieldWrapper<Content: View>: View {

    @Binding private var messageHeight: CGFloat

    let label: String
    let message: MessageType
    let content: () -> Content

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FormFieldLabel(label)
                .padding(.bottom, .xxSmall)

            content()

            ContentHeightReader(height: $messageHeight.animation(.easeOut(duration: 0.2))) {
                FormFieldMessage(message)
                    .padding(.top, .xxSmall)
            }
        }
    }

    public init(
        _ label: String,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder content: @escaping () -> Content)
    {
        self.label = label
        self.message = message
        self._messageHeight = messageHeight
        self.content = content
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

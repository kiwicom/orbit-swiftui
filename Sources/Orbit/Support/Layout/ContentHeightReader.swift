import SwiftUI

/// Invisible wrapper that communicates its current content height.
public struct ContentHeightReader<Content: View>: View {

    @Binding var height: CGFloat
    @ViewBuilder let content: Content

    public var body: some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size.height)
                }
            )
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.height = preferences
        }
    }

    public init(height: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self._height = height
        self.content = content()
    }
}

// MARK: - Previews
struct ContentHeightReaderPreviews: PreviewProvider {

    static let message: MessageType = .normal("Form Field Message")

    static var previews: some View {
        PreviewWrapper {
            StateWrapper(initialState: (CGFloat(0), Self.message)) { state in
                VStack {
                    Text("Height: \(state.0.wrappedValue)")

                    ContentHeightReader(height: state.0) {
                        FormFieldMessage(state.1.wrappedValue)
                    }

                    Button("Toggle") {
                        withAnimation(.easeInOut(duration: 1)) {
                            state.1.wrappedValue = state.1.wrappedValue == .none ? Self.message : .none
                        }
                    }
                }
                .padding()
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

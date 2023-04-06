import SwiftUI

/// An icon-based bar button for suitable for actions inside toolbar or navigation bar.
public struct BarButton: View {

    private let content: Icon.Content
    private let size: Icon.Size
    private let alignment: HorizontalAlignment
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button {
            HapticsProvider.sendHapticFeedback(.light(0.5))
            action()
        } label: {
            Icon(content: content, size: size)
                .padding(.vertical, .xSmall)
                .padding(horizontalEdges, .xSmall)
                .contentShape(Rectangle())
        }
        .buttonStyle(.barButton())
    }

    var horizontalEdges: Edge.Set {
        switch alignment {
            case .leading:      return .trailing
            case .trailing:     return .leading
            default:            return .horizontal
        }
    }

    /// Creates Orbit BarButton component using the provided icon content.
    public init(
        _ content: Icon.Content,
        size: Icon.Size = .large,
        alignment: HorizontalAlignment = .center,
        action: @escaping () -> Void
    ) {
        self.content = content
        self.size = size
        self.alignment = alignment
        self.action = action
    }
}

// MARK: - Button Style
extension BarButton {

    struct ButtonStyle: SwiftUI.ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .opacity(configuration.isPressed ? 0.5 : 1)
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

extension SwiftUI.ButtonStyle where Self == BarButton.ButtonStyle {

    static func barButton() -> Self {
        Self()
    }
}

// MARK: - Previews
struct BarButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            navigationView
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack{
            BarButton(.grid, action: {})
        }
        .previewDisplayName()
    }

    static var navigationView: some View {
        NavigationView {
            Color.cloudNormal
                .navigationBarTitle("Title", displayMode: .inline)
                .navigationBarItems(
                    leading: HStack(spacing: 0) {
                        Group {
                            BarButton(.grid, alignment: .leading, action: {})
                            BarButton(.questionCircle, action: {})
                                .foregroundColor(.blueDark)
                            BarButton(.symbol(.questionCircle, color: .redNormal), action: {})
                            BarButton(.sfSymbol("questionmark.circle.fill"), size: .normal, action: {})
                                .foregroundColor(.greenDark)
                            BarButton(.countryFlag("cz"), action: {})
                        }
                        .border(.cloudNormal.opacity(0.4))
                    }
                )
                .navigationBarItems(
                    trailing: HStack(spacing: 0) {
                        Group {
                            if #available(iOS 16.0, *) {
                                BarButton(.sfSymbol("square.and.arrow.up"), size: .normal, action: {})
                                    .fontWeight(.medium)
                            } else {
                                BarButton(.sfSymbol("square.and.arrow.up"), size: .normal, action: {})
                            }
                            BarButton(.shareIos, action: {})
                            BarButton(.grid, alignment: .trailing, action: {})
                        }
                        .foregroundColor(.inkDark)
                        .border(.cloudNormal.opacity(0.4))
                    }
                )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName()
    }
}

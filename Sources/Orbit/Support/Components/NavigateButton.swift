import SwiftUI

public struct NavigateButton: View {

    public enum State {
        case back
        case close

        var imageSymbol: Image.Symbol {
            switch self {
                case .back:     return .navigateBack
                case .close:    return .navigateClose
            }
        }
    }

    public static let insets = EdgeInsets(top: .medium, leading: .small, bottom: .medium, trailing: .large)

    private let state: State
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                Image.orbit(state.imageSymbol)
                    .padding(.top, Self.insets.top)
                    .padding(.leading, Self.insets.leading)
                    .padding(.bottom, Self.insets.bottom)
                    .padding(.trailing, Self.insets.trailing)
            }
        )
        .buttonStyle(OrbitStyle())
    }

    public init(state: State, action: @escaping () -> Void = {}) {
        self.state = state
        self.action = action
    }
}

// MARK: - Types
public extension NavigateButton {

    private struct OrbitStyle: ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(configuration.isPressed ? .inkLight : .inkDark)
        }
    }
}

// MARK: - Previews
struct NavigateBackButtonPreviews: PreviewProvider {

    public static var previews: some View {
        NavigateButton(state: .back)
            .previewLayout(.sizeThatFits)
    }
}

// MARK: - Previews
struct NavigateCloseButtonPreviews: PreviewProvider {

    public static var previews: some View {
        NavigateButton(state: .close)
            .previewLayout(.sizeThatFits)
    }
}

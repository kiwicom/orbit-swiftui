import SwiftUI

/// Orbit support component that is a special case of ``BarButton``, suitable for main navigation actions inside toolbar or navigation bar.
public struct NavigationButton: View {

    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let state: State
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }
            
            action()
        } label: {
            Image(state.imageSymbol)
        }
        .buttonStyle(NavigationButtonStyle())
    }

    /// Creates Orbit ``NavigationButton`` component.
    public init(_ state: State, action: @escaping () -> Void) {
        self.state = state
        self.action = action
    }
}

// MARK: - Types
extension NavigationButton {

    /// Orbit ``NavigationButton`` state.
    public enum State {
        case back
        case close

        var imageSymbol: ImageResource {
            switch self {
                case .back:     return .navigateBack
                case .close:    return .navigateClose
            }
        }
    }
}

// MARK: - Previews
struct NavigationButtonPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            close
            back
            navigationClose
            navigationBack
        }
    }

    static var close: some View {
        NavigationButton(.close, action: {})
            .previewLayout(.sizeThatFits)
            .previewDisplayName()
    }

    static var back: some View {
        NavigationButton(.back, action: {})
            .previewLayout(.sizeThatFits)
            .previewDisplayName()
    }

    static var navigationClose: some View {
        NavigationView {
            Color.screen
                .navigationBarTitle("Screen", displayMode: .inline)
                .navigationBarItems(
                    leading: HStack(spacing: 0) {
                        Group {
                            NavigationButton(.close, action: {})

                            BarButton {
                                // No action
                            } icon: {
                                Icon("xmark")
                            }
                            .iconColor(.inkDark)
                            .textFontWeight(.bold)

                            BarButton(.close, action: {})
                        }
                        .border(.cloudNormal.opacity(0.3))
                    }
                )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName()
    }

    static var navigationBack: some View {
        NavigationView {
            Color.screen
                .navigationBarTitle("Screen", displayMode: .inline)
                .navigationBarItems(
                    leading: HStack(spacing: 0) {
                        Group {
                            NavigationButton(.back, action: {})

                            BarButton {
                                // No action
                            } icon: {
                                Icon("arrow.backward")
                            }
                            .iconColor(.inkDark)
                            .textFontWeight(.bold)

                            BarButton(.chevronBackward, action: {})
                        }
                        .border(.cloudNormal.opacity(0.3))
                    },
                    trailing: HStack(spacing: 0) {
                        Group {
                            BarButton(.shareIos, action: {})
                            BarButton(.grid, alignment: .trailing, action: {})
                        }
                        .border(.cloudNormal.opacity(0.3))
                    }
                )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName()
    }
}

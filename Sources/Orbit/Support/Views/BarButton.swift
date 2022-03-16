import SwiftUI

public struct BarButton: View {

    private let symbol: Icon.Symbol
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                Icon(symbol, size: .medium, color: .inkNormal)
            }
        )
        .buttonStyle(NavigateButton.OrbitStyle())
    }

    public init(_ symbol: Icon.Symbol, action: @escaping () -> Void = {}) {
        self.symbol = symbol
        self.action = action
    }
}

// MARK: - Types
private extension NavigateButton {

    struct OrbitStyle: ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(configuration.isPressed ? .inkLighter : .inkNormal)
        }
    }
}

// MARK: - Previews
struct BarButtonPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            BarButton(.download)
            BarButton(.exchange)
            BarButton(.attachment)
            
            NavigationView {
                EmptyView()
                    .navigationBarTitle("Title", displayMode: .inline)
                    .navigationBarItems(leading: BarButton(.markdown))
                    .navigationBarItems(trailing: BarButton(.passengers))
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI

/// Button for NavigationBar.
public struct BarButton: View {

    private let content: Icon.Content
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button {
            HapticsProvider.sendHapticFeedback(.light(0.5))
            action()
        } label: {
            Icon(content: content)
        }
        .buttonStyle(.barButton(color: content.color))
    }

    public init(_ content: Icon.Content, action: @escaping () -> Void = {}) {
        self.content = content
        self.action = action
    }
}

// MARK: - Types
private extension BarButton {

    struct ButtonStyle: SwiftUI.ButtonStyle {

        var color: Color?

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(foregroundColor(configuration: configuration))
        }

        func foregroundColor(configuration: Configuration) -> Color? {
            let foregroundColor: Color

            if let color = color {
                foregroundColor = color
            } else {
                foregroundColor = .inkDark
            }

            return configuration.isPressed ? foregroundColor.opacity(0.6) : foregroundColor
        }
    }
}

extension SwiftUI.ButtonStyle where Self == BarButton.ButtonStyle {

    static func barButton(color: Color?) -> Self {
        Self(color: color)
    }
}

// MARK: - Types
public extension Icon.Content {

    var color: Color? {
        switch self {
            case .symbol(_, let color):             return color
            case .image, .countryFlag:              return nil
            case .sfSymbol(_, let color):           return color
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
                Color.cloudNormal
                    .navigationBarTitle("Title", displayMode: .inline)
                    .navigationBarItems(
                        leading: HStack(spacing: .small) {
                            BarButton(.grid)
                            BarButton(.markdown)
                            BarButton(.grid)
                        }
                    )
                    .navigationBarItems(
                        trailing: HStack(spacing: .small) {
                            BarButton(.grid)
                            BarButton(.passengers)
                            BarButton(.grid)
                        }
                    )
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI

/// An icon-based bar button for suitable for actions inside toolbar or navigation bar.
public struct BarButton: View {

    private let content: Icon.Content
    private let alignment: TextAlignment
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button {
            HapticsProvider.sendHapticFeedback(.light(0.5))
            action()
        } label: {
            Icon(content: content)
                .padding(edges, .xSmall)
                .contentShape(Rectangle())
        }
        .buttonStyle(.barButton(color: content.color))
    }

    var edges: Edge.Set {
        switch alignment {
            case .leading:      return [.vertical, .trailing]
            case .center:       return .all
            case .trailing:     return [.vertical, .leading]
        }
    }

    public init(_ content: Icon.Content, alignment: TextAlignment = .center, action: @escaping () -> Void = {}) {
        self.content = content
        self.alignment = alignment
        self.action = action
    }
}

// MARK: - Button Style
extension BarButton {

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
            case .sfSymbol(_, let color, _):        return color
        }
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
        BarButton(.grid)
            .previewDisplayName()
    }

    static var navigationView: some View {
        NavigationView {
            Color.cloudNormal
                .navigationBarTitle("Title", displayMode: .inline)
                .navigationBarItems(
                    leading: HStack(spacing: 0) {
                        Group {
                            BarButton(.grid, alignment: .leading)
                            BarButton(.sfSymbol("questionmark.circle.fill"))
                            BarButton(.questionCircle)
                            BarButton(.countryFlag("cz"))
                        }
                        .border(Color.cloudNormal.opacity(0.4))
                    }
                )
                .navigationBarItems(
                    trailing: HStack(spacing: 0) {
                        Group {
                            BarButton(.shareIos)
                            BarButton(.sfSymbol("square.and.arrow.up", weight: .medium))
                            BarButton(.grid, alignment: .trailing)
                        }
                        .border(Color.cloudNormal.opacity(0.4))
                    }
                )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName()
    }
}

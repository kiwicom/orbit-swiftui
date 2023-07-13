import SwiftUI

/// An icon-based button.
public struct IconButton<Icon: View>: View {

    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    @ViewBuilder private let icon: Icon
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }
            
            action()
        } label: {
            icon
                .font(.system(size: Orbit.Icon.Size.normal.value))
                .foregroundColor(.inkDark)
                .contentShape(Rectangle())
        }
        .buttonStyle(IconButtonStyle())
    }
}

// MARK: - Icons
public extension IconButton {

    /// Creates Orbit IconButton component with custom icon.
    init(
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
        self.action = action
        self.icon = icon()
    }

    /// Creates Orbit IconButton component.
    init(
        _ icon: Orbit.Icon.Symbol,
        action: @escaping () -> Void
    ) where Icon == Orbit.Icon {
        self.init() {
            action()
        } icon: {
            Icon(icon)
        }
    }
}

// MARK: - Button Style
public struct IconButtonStyle: ButtonStyle {

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Previews
struct IconButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: .xxSmall) {
            Group {
                IconButton(.grid, action: {})

                IconButton {
                    // No Action
                } icon: {
                    CountryFlag("us")
                }

                IconButton {
                    // No Action
                } icon: {
                    Icon("circle.fill")
                }
            }
            .border(.inkNormal, width: .hairline)
        }
        .previewDisplayName()
    }
}

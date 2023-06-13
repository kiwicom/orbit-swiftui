import SwiftUI

/// An icon-based button.
public struct IconButton<Icon: View>: View {

    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let size: Orbit.Icon.Size
    private let action: () -> Void
    @ViewBuilder private let icon: Icon

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }
            
            action()
        } label: {
            icon
                .font(.system(size: size.value))
                .foregroundColor(.inkDark)
                .contentShape(Rectangle())
        }
        .buttonStyle(IconButtonStyle())
    }

    /// Creates Orbit IconButton component with custom icon.
    public init(
        size: Orbit.Icon.Size = .normal,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
        self.size = size
        self.action = action
        self.icon = icon()
    }

    /// Creates Orbit IconButton component.
    init(
        _ icon: Orbit.Icon.Symbol,
        size: Orbit.Icon.Size = .normal,
        action: @escaping () -> Void
    ) where Icon == Orbit.Icon {
        self.init(
            size: size
        ) {
            action()
        } icon: {
            Icon(icon, size: size)
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

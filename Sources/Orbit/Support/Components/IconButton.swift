import SwiftUI

/// Orbit support component that displays an icon-based button.
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
        }
        .buttonStyle(IconButtonStyle())
    }
    
    /// Creates Orbit ``IconButton`` component with custom icon.
    public init(
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
        self.action = action
        self.icon = icon()
    }
}

// MARK: - Convenience Inits
public extension IconButton {

    /// Creates Orbit ``IconButton`` component.
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

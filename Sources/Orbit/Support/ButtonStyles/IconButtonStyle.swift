import SwiftUI

/// Button style for Orbit ``IconButton`` component.
public struct IconButtonStyle: ButtonStyle {

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .contentShape(Rectangle())
    }
    
    /// Create button style for Orbit ``IconButton`` component.
    public init() {}
}

// MARK: - Previews
struct IconButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(IconButtonStyle())
                .padding(1)
                .border(.cloudNormal)
        }
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Icon(.remove)
        }
    }
}

import SwiftUI

/// Button style for Orbit ``ButtonStackBuilder``.
struct ButtonStackStyle: PrimitiveButtonStyle {

    @Environment(\.buttonPriority) private var buttonPriority
    @Environment(\.isSubtle) private var isSubtle
    @Environment(\.status) private var status

    func makeBody(configuration: Configuration) -> some View {
        switch resolvedPriority {
            case .primary:
                SwiftUI.Button(configuration)
                    .buttonStyle(OrbitButtonStyle(type: .status(nil)))
            case .secondary:
                SwiftUI.Button(configuration)
                    .buttonStyle(OrbitButtonLinkButtonStyle(type: .status(nil)))
        }
    }

    private var resolvedPriority: ButtonPriority {
        buttonPriority ?? .primary
    }
    
    /// Create dynamic button style for Orbit ``ButtonStackStyle``.
    init() {}
}

// MARK: - Previews
struct ButtonStackStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(ButtonStackStyle())
                .status(nil)
            
            button
                .buttonStyle(ButtonStackStyle())
                .buttonPriority(.primary)
            
            button
                .buttonStyle(ButtonStackStyle())
                .buttonPriority(.secondary)
            
            button
                .buttonStyle(ButtonStackStyle())
                .status(.critical)
        }
        .status(.info)
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("ButtonStackStyle")
        }
    }
}

import SwiftUI

/// Button style for Orbit ``NavigationButton`` component.
public struct NavigationButtonStyle: ButtonStyle {

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textColor(configuration.isPressed ? .inkLight : .inkDark)
            .padding([.vertical, .trailing], .small)
            .contentShape(Rectangle())
    }
    
    /// Create button style for Orbit ``NavigationButton`` component.
    public init() {}
}

// MARK: - Previews
struct NavigationButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(NavigationButtonStyle())
                .padding(1)
                .border(.cloudNormal)
        }
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Image(.navigateClose)
        }
    }
}

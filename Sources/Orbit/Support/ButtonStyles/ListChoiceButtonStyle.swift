import SwiftUI

/// Button style for Orbit ``ListChoice`` component.
public struct ListChoiceButtonStyle: ButtonStyle {

    @Environment(\.backgroundShape) private var backgroundShape
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                backgroundColor(isPressed: configuration.isPressed)
                    .contentShape(Rectangle())
            )
    }

    @ViewBuilder private func backgroundColor(isPressed: Bool) -> some View {
        if isPressed {
            resolvedActiveBackground
        } else {
            resolvedInactiveBackground
        }
    }
    
    @ViewBuilder private var resolvedInactiveBackground: some View {
        if let backgroundShape {
            backgroundShape.inactiveView
        } else {
            Color.clear
        }
    }
    
    @ViewBuilder private var resolvedActiveBackground: some View {
        if let backgroundShape {
            backgroundShape.activeView
        } else {
            Color.inkNormal.opacity(0.06)
        }
    }
    
    /// Create button style for Orbit ``ListChoice`` component.
    public init() {}
}

// MARK: - Previews
struct ListChoiceButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            colors
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(ListChoiceButtonStyle())
        }
        .previewDisplayName()
    }
    
    static var colors: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .backgroundStyle(.orangeLight)
            
            button
                .backgroundStyle(.orangeLight, active: .greenLight)
            
            button
                .backgroundStyle(Gradient.bundleBasic.background, active: .redLight)
        }
        .buttonStyle(ListChoiceButtonStyle())
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("ListChoiceButtonStyle")
                .padding(.medium)
        }
    }
}

import SwiftUI

/// Button style for Orbit  ``Tile``, ``ChoiceTile`` and similar components.
public struct TileButtonStyle: ButtonStyle {

    public static let verticalTextPadding: CGFloat = 14 // = 52 height @ normal size

    @Environment(\.backgroundShape) private var backgroundShape
    
    private let style: TileBorderStyle
    private let isSelected: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor(isPressed: configuration.isPressed))
            .tileBorder(style, isSelected: isSelected)
    }
    
    @ViewBuilder func backgroundColor(isPressed: Bool) -> some View {
        if isPressed {
            resolvedActiveBackground
        } else {
            resolvedInactiveBackground
        }
    }
    
    @ViewBuilder var resolvedInactiveBackground: some View {
        if let backgroundShape {
            backgroundShape.inactiveView
        } else {
            Color.whiteDarker
        }
    }
    
    @ViewBuilder var resolvedActiveBackground: some View {
        if let backgroundShape {
            backgroundShape.activeView
        } else {
            Color.whiteHover
        }
    }
    
    /// Create button style for Orbit ``Tile``, ``ChoiceTile`` and similar components.
    public init(style: TileBorderStyle = .default, isSelected: Bool = false) {
        self.style = style
        self.isSelected = isSelected
    }
}

// MARK: - Previews
struct TileButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            styles
            colors
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var styles: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(TileButtonStyle(style: .default))
            
            button
                .buttonStyle(TileButtonStyle(style: .iOS))
            
            button
                .buttonStyle(TileButtonStyle(style: .plain))
            
            button
                .buttonStyle(TileButtonStyle(style: .none))
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
        .buttonStyle(TileButtonStyle())
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("TileButtonStyle")
                .padding(.medium)
        }
    }
}

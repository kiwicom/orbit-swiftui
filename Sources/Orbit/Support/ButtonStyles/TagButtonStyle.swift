import SwiftUI

/// Button style for Orbit ``Tag`` component.
public struct TagButtonStyle: ButtonStyle {

    public static let horizontalPadding: CGFloat = .xSmall
    public static let verticalPadding: CGFloat = 6 // = 32 height @ normal size text size

    @Environment(\.backgroundColor) private var backgroundColor
    @Environment(\.iconColor) private var iconColor
    @Environment(\.textColor) private var textColor
    
    private let style: TagStyle
    private let isFocused: Bool
    private let isSelected: Bool

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .xSmall) {
            configuration.label
                .foregroundColor(resolvedTextColor)
                .textColor(resolvedTextColor)
                .lineLimit(1)

            if case .removable(let removeAction) = style {
                Icon(.closeCircle)
                    .iconSize(.small)
                    .iconColor(resolvedIconColor(isPressed: configuration.isPressed))
                    .onTapGesture(perform: removeAction)
                    .accessibility(addTraits: .isButton)
            }
        }
        .textFontWeight(.medium)
        .padding(.horizontal, Self.horizontalPadding)
        .padding(.vertical, Self.verticalPadding)
        .background(
            resolvedBackgroundColor(isPressed: configuration.isPressed)
                .animation(nil)
        )
        .cornerRadius(BorderRadius.default)
    }
    
    @ViewBuilder func resolvedBackgroundColor(isPressed: Bool) -> some View {
        if isPressed {
            resolvedActiveBackground
        } else {
            resolvedInactiveBackground
        }
    }
    
    @ViewBuilder var resolvedInactiveBackground: some View {
        if let backgroundColor {
            backgroundColor.inactiveView
        } else {
            inactiveBackgroundColor
        }
    }
    
    @ViewBuilder var resolvedActiveBackground: some View {
        if let backgroundColor {
            backgroundColor.activeView
        } else {
            activeBackgroundColor
        }
    }
    
    var inactiveBackgroundColor: Color {
        switch (isFocused, isSelected) {
            case (true, false):             return .blueLight
            case (true, true):              return .blueNormal
            case (false, false):            return .cloudNormal
            case (false, true):             return .inkLightHover
        }
    }
    
    var activeBackgroundColor: Color {
        switch (isFocused, isSelected) {
            case (true, false):             return .blueLightActive
            case (true, true):              return .blueNormalActive
            case (false, false):            return .cloudNormalActive
            case (false, true):             return .inkNormalHover
        }
    }
    
    var resolvedTextColor: Color {
        textColor ?? labelColor
    }
    
    var labelColor: Color {
        switch (isFocused, isSelected) {
            case (_, true):                 return .whiteNormal
            case (true, false):             return .blueDarker
            case (false, false):            return .inkDark
        }
    }

    func resolvedIconColor(isPressed: Bool) -> Color {
        iconColor ?? iconColor(isPressed: isPressed)
    }
    
    func iconColor(isPressed: Bool) -> Color {
        switch (isSelected, isFocused, isPressed) {
            case (true, _, _):              return .whiteNormal
            case (false, true, false):      return .blueDarker.opacity(0.3)
            case (false, false, false):     return .inkDark.opacity(0.3)
            // Pressed
            case (false, true, true):       return .blueDarker
            case (false, false, true):      return .inkDark
        }
    }
    
    /// Create button style for Orbit ``Tag`` component.
    public init(
        style: TagStyle,
        isFocused: Bool,
        isSelected: Bool
    ) {
        self.style = style
        self.isFocused = isFocused
        self.isSelected = isSelected
    }
}

// MARK: - Previews
struct TagButtonStylePreviews: PreviewProvider {
    
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
                .buttonStyle(TagButtonStyle(style: .default, isFocused: false, isSelected: false))
            
            button
                .buttonStyle(TagButtonStyle(style: .default, isFocused: true, isSelected: false))
            
            button
                .buttonStyle(TagButtonStyle(style: .default, isFocused: true, isSelected: true))
            
            button
                .buttonStyle(TagButtonStyle(style: .removable(action: {}), isFocused: true, isSelected: false))
            
            button
                .buttonStyle(TagButtonStyle(style: .removable(action: {}), isFocused: true, isSelected: true))
            
            button
                .buttonStyle(TagButtonStyle(style: .removable(action: {}), isFocused: false, isSelected: false))
            
            button
                .buttonStyle(TagButtonStyle(style: .removable(action: {}), isFocused: false, isSelected: true))
        }
        .previewDisplayName()
    }
    
    static var colors: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .backgroundColor(.orangeLight)
                .textColor(.orangeDark)
            
            button
                .backgroundColor(.orangeLight, active: .greenLight)
                .textColor(.orangeDark)
            
            button
                .backgroundColor(Gradient.bundleBasic.background, active: .redLight)
            
            button
                .buttonStyle(TagButtonStyle(style: .removable(action: {}), isFocused: true, isSelected: true))
                .iconColor(.blueLight)
                .textColor(.blueLight)
        }
        .buttonStyle(TagButtonStyle(style: .default, isFocused: false, isSelected: false))
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("TagButtonStyle")
        }
    }
}

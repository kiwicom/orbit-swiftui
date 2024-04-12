import SwiftUI

/// Button style for Orbit ``Tag`` component.
public struct TagButtonStyle: ButtonStyle {

    public static let horizontalPadding: CGFloat = .xSmall
    public static let verticalPadding: CGFloat = 6 // = 32 height @ normal size text size

    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.iconColor) private var iconColor
    @Environment(\.textColor) private var textColor

    private let isFocused: Bool
    private let isSelected: Bool
    private let removeAction: (() -> Void)?

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .xSmall) {
            configuration.label
                .foregroundColor(resolvedTextColor)
                .textColor(resolvedTextColor)
                .lineLimit(1)

            if let removeAction {
                IconButton(.closeCircle) {
                    removeAction()
                }
                .iconColor(resolvedIconColor(isPressed: configuration.isPressed))
                .iconSize(.small)
            }
        }
        .textFontWeight(.medium)
        .padding(.horizontal, Self.horizontalPadding)
        .padding(.vertical, Self.verticalPadding)
        .background(
            resolvedBackgroundColor(isPressed: configuration.isPressed)
        )
        .cornerRadius(BorderRadius.default)
        .animation(nil, value: isSelected)
    }
    
    @ViewBuilder private func resolvedBackgroundColor(isPressed: Bool) -> some View {
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
            inactiveBackgroundColor
        }
    }
    
    @ViewBuilder private var resolvedActiveBackground: some View {
        if let backgroundShape {
            backgroundShape.activeView
        } else {
            activeBackgroundColor
        }
    }
    
    private var inactiveBackgroundColor: Color {
        switch (isFocused, isSelected) {
            case (true, false):             return .blueLight
            case (true, true):              return .blueNormal
            case (false, false):            return .cloudNormal
            case (false, true):             return .inkLightHover
        }
    }
    
    private var activeBackgroundColor: Color {
        switch (isFocused, isSelected) {
            case (true, false):             return .blueLightActive
            case (true, true):              return .blueNormalActive
            case (false, false):            return .cloudNormalActive
            case (false, true):             return .inkNormalHover
        }
    }
    
    private var resolvedTextColor: Color {
        textColor ?? labelColor
    }
    
    private var labelColor: Color {
        switch (isFocused, isSelected) {
            case (_, true):                 return .whiteNormal
            case (true, false):             return .blueDarker
            case (false, false):            return .inkDark
        }
    }

    private func resolvedIconColor(isPressed: Bool) -> Color {
        iconColor ?? iconColor(isPressed: isPressed)
    }
    
    private func iconColor(isPressed: Bool) -> Color {
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
        isFocused: Bool,
        isSelected: Bool,
        removeAction: (() -> Void)?
    ) {
        self.isFocused = isFocused
        self.isSelected = isSelected
        self.removeAction = removeAction
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
                .buttonStyle(TagButtonStyle(isFocused: false, isSelected: false, removeAction: nil))

            button
                .buttonStyle(TagButtonStyle(isFocused: true, isSelected: false, removeAction: nil))

            button
                .buttonStyle(TagButtonStyle(isFocused: true, isSelected: true, removeAction: nil))

            button
                .buttonStyle(TagButtonStyle(isFocused: true, isSelected: false, removeAction: {}))

            button
                .buttonStyle(TagButtonStyle(isFocused: true, isSelected: true, removeAction: {}))

            button
                .buttonStyle(TagButtonStyle(isFocused: false, isSelected: false, removeAction: {}))

            button
                .buttonStyle(TagButtonStyle(isFocused: false, isSelected: true, removeAction: {}))
        }
        .previewDisplayName()
    }
    
    static var colors: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .backgroundStyle(.orangeLight)
                .textColor(.orangeDark)
            
            button
                .backgroundStyle(.orangeLight, active: .greenLight)
                .textColor(.orangeDark)
            
            button
                .backgroundStyle(Gradient.bundleBasic.background, active: .redLight)
            
            button
                .buttonStyle(TagButtonStyle(isFocused: true, isSelected: true, removeAction: {}))
                .iconColor(.blueLight)
                .textColor(.blueLight)
        }
        .buttonStyle(TagButtonStyle(isFocused: false, isSelected: false, removeAction: nil))
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

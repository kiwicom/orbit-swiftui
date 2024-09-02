import SwiftUI

/// Button style for Orbit ``Radio`` component.
public struct RadioButtonStyle: ButtonStyle {

    public static let size: CGFloat = 20

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.isEnabled) private var isEnabled

    private let state: RadioState
    private let isChecked: Bool

    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            indicator(isPressed: configuration.isPressed)
            configuration.label
        }
        .accessibility(addTraits: isChecked ? .isSelected : [])
    }

    private func indicator(isPressed: Bool) -> some View {
        indicatorShape
            .strokeBorder(indicatorStrokeColor(isPressed: isPressed), lineWidth: strokeWidth)
            .background(
                indicatorShape
                    .fill(indicatorBackgroundColor)
            )
            .overlay(
                indicatorShape
                    .inset(by: -0.5)
                    .stroke(state == .error ? Color.redLight : Color.clear, lineWidth: errorStrokeWidth)
            )
            .overlay(
                indicatorShape
                    .strokeBorder(indicatorOverlayStrokeColor(isPressed: isPressed), lineWidth: indicatorStrokeWidth)
            )
            .frame(width: size, height: size)
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.2), value: state)
            .animation(.easeOut(duration: 0.15), value: isChecked)
            .alignmentGuide(.firstTextBaseline) { _ in
                size * 0.75 + 3 * (sizeCategory.controlRatio - 1)
            }
    }

    private var indicatorShape: some InsettableShape {
        Circle()
    }

    private func indicatorStrokeColor(isPressed: Bool) -> some ShapeStyle {
        switch (isEnabled, isChecked, isPressed) {
            case (true, true, false):       return .blueNormal
            case (true, true, true):        return .blueLightActive
            case (_, _, _):                 return .cloudDark
        }
    }

    private var indicatorBackgroundColor: some ShapeStyle {
        switch (isEnabled, isChecked) {
            case (false, false):            return .cloudNormal
            case (_, _):                    return .clear
        }
    }

    private func indicatorOverlayStrokeColor(isPressed: Bool) -> some ShapeStyle {
        switch (state, isPressed) {
            case (.normal, true):           return .blueNormal
            case (.error, true):            return .redLightActive
            case (.error, false):           return .redNormal
            case (_, _):                    return .clear
        }
    }

    private var size: CGFloat {
        Self.size * sizeCategory.controlRatio
    }

    private var strokeWidth: CGFloat {
        (isChecked ? 6 : 2) * sizeCategory.controlRatio
    }

    private var errorStrokeWidth: CGFloat {
        3 * sizeCategory.controlRatio
    }

    private var indicatorStrokeWidth: CGFloat {
        2 * sizeCategory.controlRatio
    }
    
    /// Create button style for Orbit ``Radio`` component.
    public init(state: RadioState, isChecked: Bool) {
        self.state = state
        self.isChecked = isChecked
    }
}

// MARK: - Previews
struct RadioButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            styles
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var styles: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(RadioButtonStyle(state: .normal, isChecked: false))
            
            button
                .buttonStyle(RadioButtonStyle(state: .normal, isChecked: true))
            
            button
                .buttonStyle(RadioButtonStyle(state: .error, isChecked: false))
            
            button
                .buttonStyle(RadioButtonStyle(state: .error, isChecked: true))
        }
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("RadioButtonStyle")
        }
    }
}

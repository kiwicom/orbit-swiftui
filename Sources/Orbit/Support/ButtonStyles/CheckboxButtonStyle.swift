import SwiftUI

/// Button style for Orbit ``Checkbox`` component.
public struct CheckboxButtonStyle: ButtonStyle {

    public static let size: CGFloat = 20

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) var textColor

    private let state: Checkbox.State
    private let isChecked: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            indicator(isPressed: configuration.isPressed)
            configuration.label
        }
        .accessibility(addTraits: isChecked ? .isSelected : [])
    }

    func indicator(isPressed: Bool) -> some View {
        shape
            .strokeBorder(indicatorStrokeColor(isPressed: isPressed), lineWidth: indicatorStrokeWidth)
            .background(
                shape
                    .fill(indicatorBackgroundColor(isPressed: isPressed))
            )
            .overlay(
                Icon(.check)
                    .iconSize(.small)
                    .iconColor(isEnabled ? .whiteNormal : .cloudNormal)
                    .opacity(isChecked ? 1 : 0)
            )
            .overlay(
                shape
                    .inset(by: -inset)
                    .stroke(state == .error ? Color.redLight : Color.clear, lineWidth: errorStrokeWidth)
            )
            .overlay(
                shape
                    .strokeBorder(indicatorOverlayStrokeColor(isPressed: isPressed), lineWidth: indicatorStrokeWidth)
            )
            .frame(width: size, height: size)
            .animation(.easeOut(duration: 0.2), value: state)
            .animation(.easeOut(duration: 0.15), value: isChecked)
            .alignmentGuide(.firstTextBaseline) { _ in
                size * 0.75 + 3 * (sizeCategory.controlRatio - 1)
            }
    }

    var shape: some InsettableShape {
        RoundedRectangle(cornerRadius: BorderRadius.default * sizeCategory.controlRatio, style: .continuous)
    }

    func indicatorStrokeColor(isPressed: Bool) -> some ShapeStyle {
        switch (isEnabled, isChecked, isPressed) {
            case (true, true, false):       return .blueNormal
            case (true, true, true):        return .blueLightActive
            case (_, _, _):                 return .cloudDark
        }
    }

    func indicatorBackgroundColor(isPressed: Bool) -> some ShapeStyle {
        switch (isEnabled, isChecked, isPressed) {
            case (true, true, false):       return .blueNormal
            case (true, true, true):        return .blueLightActive
            case (false, false, _):         return .cloudNormal
            case (false, true, _):          return .cloudDark
            case (_, _, _):                 return .clear
        }
    }

    func indicatorOverlayStrokeColor(isPressed: Bool) -> some ShapeStyle {
        switch (state, isPressed) {
            case (.normal, true):           return .blueNormal
            case (.error, true):            return .redLightActive
            case (.error, false):           return .redNormal
            case (_, _):                    return .clear
        }
    }
    
    var labelColor: Color {
        isEnabled
            ? textColor ?? .inkDark
            : .cloudDarkHover
    }

    var descriptionColor: Color {
        isEnabled
            ? .inkNormal
            : .cloudDarkHover
    }

    var size: CGFloat {
        Self.size * sizeCategory.controlRatio
    }

    var inset: CGFloat {
        0.5 * sizeCategory.controlRatio
    }

    var errorStrokeWidth: CGFloat {
        3 * sizeCategory.controlRatio
    }

    var indicatorStrokeWidth: CGFloat {
        2 * sizeCategory.controlRatio
    }
    
    /// Create button style for Orbit ``Checkbox`` component.
    public init(state: Checkbox.State, isChecked: Bool) {
        self.state = state
        self.isChecked = isChecked
    }
}

// MARK: - Previews
struct CheckboxButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            styles
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var styles: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(CheckboxButtonStyle(state: .normal, isChecked: false))
                .disabled(true)
            
            button
                .buttonStyle(CheckboxButtonStyle(state: .normal, isChecked: true))
                .disabled(true)
            
            button
                .buttonStyle(CheckboxButtonStyle(state: .normal, isChecked: false))
            
            button
                .buttonStyle(CheckboxButtonStyle(state: .normal, isChecked: true))
            
            button
                .buttonStyle(CheckboxButtonStyle(state: .error, isChecked: false))
            
            button
                .buttonStyle(CheckboxButtonStyle(state: .error, isChecked: true))
        }
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("CheckboxButtonStyle")
        }
    }
}

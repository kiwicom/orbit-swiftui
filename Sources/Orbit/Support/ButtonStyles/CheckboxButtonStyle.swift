import SwiftUI

/// Button style for Orbit ``Checkbox`` component.
public struct CheckboxButtonStyle: ButtonStyle {

    public static let size: CGFloat = 20

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor

    private let state: CheckboxState
    private let isChecked: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            indicator(isPressed: configuration.isPressed)
            configuration.label
        }
        .accessibility(addTraits: isChecked ? .isSelected : [])
    }

    private func indicator(isPressed: Bool) -> some View {
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
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.2), value: state)
            .animation(.easeOut(duration: 0.15), value: isChecked)
            .alignmentGuide(.firstTextBaseline) { _ in
                size * 0.75 + 3 * (sizeCategory.controlRatio - 1)
            }
    }

    private var shape: some InsettableShape {
        RoundedRectangle(cornerRadius: BorderRadius.default * sizeCategory.controlRatio, style: .continuous)
    }

    private func indicatorStrokeColor(isPressed: Bool) -> some ShapeStyle {
        switch (isEnabled, isChecked, isPressed) {
            case (true, true, false):       return .blueNormal
            case (true, true, true):        return .blueLightActive
            case (_, _, _):                 return .cloudDark
        }
    }

    private func indicatorBackgroundColor(isPressed: Bool) -> some ShapeStyle {
        switch (isEnabled, isChecked, isPressed) {
            case (true, true, false):       return .blueNormal
            case (true, true, true):        return .blueLightActive
            case (false, false, _):         return .cloudNormal
            case (false, true, _):          return .cloudDark
            case (_, _, _):                 return .clear
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
    
    private var labelColor: Color {
        isEnabled
            ? textColor ?? .inkDark
            : .cloudDarkHover
    }

    private var descriptionColor: Color {
        isEnabled
            ? .inkNormal
            : .cloudDarkHover
    }

    private var size: CGFloat {
        Self.size * sizeCategory.controlRatio
    }

    private var inset: CGFloat {
        0.5 * sizeCategory.controlRatio
    }

    private var errorStrokeWidth: CGFloat {
        3 * sizeCategory.controlRatio
    }

    private var indicatorStrokeWidth: CGFloat {
        2 * sizeCategory.controlRatio
    }
    
    /// Create button style for Orbit ``Checkbox`` component.
    public init(state: CheckboxState, isChecked: Bool) {
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

import SwiftUI

public enum InputState {
    case disabled
    case `default`
    case modified

    public var textColor: Color {
        switch self {
            case .disabled:         return .cloudNormalActive
            case .default:          return .inkNormal
            case .modified:         return .blueDark
        }
    }
}

/// Button-like appearance for inputs that share common layout with a prefix and suffix.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
struct InputStyle: ButtonStyle {

    private let prefix: Icon.Content
    private let suffix: Icon.Content
    private let state: InputState
    private let value: String?
    private let message: MessageType
    private let isEditing: Bool

    init(
        prefix: Icon.Content,
        suffix: Icon.Content,
        state: InputState,
        value: String?,
        message: MessageType,
        isEditing: Bool
    ) {
        self.prefix = prefix
        self.suffix = suffix
        self.state = state
        self.value = value
        self.message = message
        self.isEditing = isEditing
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            prefix.view(defaultColor: prefixColor)
                .padding(.trailing, .xxxSmall)

            configuration.label
                .lineLimit(1)
                .padding(.leading, .xxSmall)

            Spacer(minLength: 0)

            suffix.view(defaultColor: suffixColor)
        }
        .foregroundColor(state.textColor)
        .frame(height: Layout.preferredButtonHeight)
        .padding(.horizontal, Spacing.xSmall)
        .background(backgroundColor(isPressed: configuration.isPressed).animation(.default, value: message))
        .cornerRadius(BorderRadius.default)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.default)
                .strokeBorder(outlineColor(isPressed: configuration.isPressed), lineWidth: BorderWidth.emphasis)
        )
        .disabled(state == .disabled)
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        switch (state, isPressed) {
            case (.disabled, _):        return .cloudLight
            case (.default, true):      return .cloudNormalHover
            case (.default, false):     return .cloudNormal
            case (.modified, true):     return .blueLight
            case (.modified, false):    return .blueLight.opacity(0.7)
        }
    }

    private var prefixColor: Color {
        suffixColor
    }

    private var suffixColor: Color {
        switch (value, state) {
            case (_, .disabled):        return .cloudDarkerActive
            case (.none, _):            return .inkLighter
            case (_, .modified):        return .blueDark
            default:                    return .inkLighter
        }
    }

    private func outlineColor(isPressed: Bool) -> Color {
        switch (message, state, isEditing) {
            case (.error, _, _):        return .redNormal
            case (.warning, _, _):      return .orangeNormal
            case (.help, _, _):         return .blueNormal
            case (_, .modified, _):     return .blueDark
            case (_, .default, true):   return .blueNormal
            default:                    return backgroundColor(isPressed: isPressed)
        }
    }
}

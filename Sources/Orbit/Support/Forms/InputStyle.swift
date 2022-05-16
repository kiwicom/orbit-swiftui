import SwiftUI

public enum InputState {
    case disabled
    case `default`
    case modified

    public var textColor: Color {
        switch self {
            case .disabled:         return .cloudDarkerActive
            case .default:          return .inkNormal
            case .modified:         return .blueDark
        }
    }
    
    public var placeholderColor: Color {
        switch self {
            case .disabled:             return textColor
            case .default, .modified:   return .inkLighter
        }
    }

    public var textUIColor: UIColor {
        switch self {
            case .disabled:         return .cloudDarkerActive
            case .default:          return .inkNormal
            case .modified:         return .blueDark
        }
    }

    public var placeholderUIColor: UIColor {
        switch self {
            case .disabled:             return textUIColor
            case .default, .modified:   return .inkLighter
        }
    }
}

/// Content for inputs that share common layout with a prefix and suffix.
struct InputContent<Content: View>: View {
    
    var prefix: Icon.Content = .none
    var suffix: Icon.Content = .none
    var state: InputState = .default
    var value: String?
    var message: MessageType = .none
    var isPressed: Bool = false
    var isEditing: Bool = false
    var suffixAction = {}
    let label: () -> Content
    
    var body: some View {
        HStack(spacing: 0) {
            Icon(prefix, size: .large)
                .foregroundColor(prefixColor)
                .padding(.horizontal, .xSmall)

            label()
                .lineLimit(1)
                .padding(.leading, prefix.isEmpty ? .small : 0)

            Spacer(minLength: 0)

            Icon(suffix, size: .large)
                .foregroundColor(suffixColor)
                .padding(.horizontal, .xSmall)
                .contentShape(Rectangle())
                .onTapGesture(perform: suffixAction)
        }
        .foregroundColor(state.textColor)
        .frame(height: Layout.preferredButtonHeight)
        .background(backgroundColor(isPressed: isPressed).animation(.default, value: message))
        .cornerRadius(BorderRadius.default)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.default)
                .strokeBorder(outlineColor(isPressed: isPressed), lineWidth: BorderWidth.emphasis)
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
        switch state {
            case .disabled:             return .cloudDarkerActive
            case .modified:             return .blueDark
            case .default:              return .inkNormal
        }
    }

    private var suffixColor: Color {
        switch state {
            case .disabled:             return .cloudDarkerActive
            case .modified:             return .blueDark
            case .default:              return .inkLight
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

/// Button-like appearance for inputs that share common layout with a prefix and suffix.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
struct InputStyle: ButtonStyle {

    var prefix: Icon.Content = .none
    var suffix: Icon.Content = .none
    var state: InputState = .default
    var value: String?
    var message: MessageType = .none
    var isEditing = false

    func makeBody(configuration: Configuration) -> some View {
        InputContent(
            prefix: prefix,
            suffix: suffix,
            state: state,
            value: value,
            message: message,
            isPressed: configuration.isPressed,
            isEditing: isEditing
        ) {
            configuration.label
        }
    }

}

import SwiftUI

/// Content for inputs that share common layout with a prefix and suffix.
struct InputContent<Content: View>: View {

    @Environment(\.idealSize) var idealSize

    var prefix: Icon.Content = .none
    var suffix: Icon.Content = .none
    var state: InputState = .default
    var message: MessageType = .none
    var isPressed: Bool = false
    var isEditing: Bool = false
    var suffixAction: (() -> Void)? = nil
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(spacing: 0) {
            prefixIcon

            content
                .lineLimit(1)
                .padding(.leading, prefix.isEmpty ? .small : 0)

            if idealSize.horizontal == nil {
                Spacer(minLength: 0)
            }

            TextStrut(.normal)
                .padding(.vertical, Button.Size.default.verticalPadding)

            if let suffixAction = suffixAction {
                suffixIcon
                    .onTapGesture(perform: suffixAction)
                    .accessibility(addTraits: .isButton)
            } else {
                suffixIcon
            }
        }
        .foregroundColor(state.textColor)
        .background(backgroundColor(isPressed: isPressed).animation(.default, value: message))
        .cornerRadius(BorderRadius.default)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.default)
                .strokeBorder(outlineColor(isPressed: isPressed), lineWidth: BorderWidth.emphasis)
        )
        .disabled(state == .disabled)
    }

    @ViewBuilder var prefixIcon: some View {
        Icon(content: prefix, size: .large)
            .foregroundColor(prefixColor)
            .padding(.horizontal, .xSmall)
            .accessibility(.inputPrefix)
    }

    @ViewBuilder var suffixIcon: some View {
        Icon(content: suffix, size: .large)
            .foregroundColor(suffixColor)
            .padding(.horizontal, .xSmall)
            .contentShape(Rectangle())
            .accessibility(.inputSuffix)
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

// MARK: - Previews
struct InputContentPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            InputContent(prefix: .visa, suffix: .checkCircle, state: .default) {
                contentPlaceholder
            }
            .padding(.medium)

            InputContent(prefix: .visa, suffix: .checkCircle, state: .default, message: .error("", icon: .alertCircle)) {
                contentPlaceholder
            }
            .padding(.medium)
        }
        .previewLayout(.sizeThatFits)
    }
}

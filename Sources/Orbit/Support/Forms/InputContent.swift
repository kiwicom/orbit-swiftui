import SwiftUI

/// Content for inputs that share common layout with a prefix and suffix.
struct InputContent<Content: View>: View {

    @Environment(\.idealSize) var idealSize
    @Environment(\.isEnabled) var isEnabled

    var prefix: Icon.Content = .none
    var suffix: Icon.Content = .none
    var prefixAccessibilityID: AccessibilityID = .selectPrefix
    var suffixAccessibilityID: AccessibilityID = .selectSuffix
    var state: InputState = .default
    var message: Message? = nil
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
        .foregroundColor(isEnabled ? state.textColor : .cloudDarkActive)
        .background(backgroundColor(isPressed: isPressed).animation(.default, value: message))
        .cornerRadius(BorderRadius.default)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.default)
                .strokeBorder(outlineColor(isPressed: isPressed), lineWidth: BorderWidth.emphasis)
        )
    }

    @ViewBuilder var prefixIcon: some View {
        Icon(content: prefix, size: .large)
            .foregroundColor(prefixColor)
            .padding(.horizontal, .xSmall)
            .accessibility(prefixAccessibilityID)
    }

    @ViewBuilder var suffixIcon: some View {
        Icon(content: suffix, size: .large)
            .foregroundColor(suffixColor)
            .padding(.horizontal, .xSmall)
            .contentShape(Rectangle())
            .accessibility(suffixAccessibilityID)
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if isEnabled == false {
            return .cloudLight
        }

        switch (state, isPressed) {
            case (.default, true):      return .cloudNormalHover
            case (.default, false):     return .cloudNormal
            case (.modified, true):     return .blueLight
            case (.modified, false):    return .blueLight.opacity(0.7)
        }
    }

    private var prefixColor: Color {
        if isEnabled == false {
            return .cloudDarkActive
        }

        switch state {
            case .modified:             return .blueDark
            case .default:              return .inkDark
        }
    }

    private var suffixColor: Color {
        if isEnabled == false {
            return .cloudDarkActive
        }

        switch state {
            case .modified:             return .blueDark
            case .default:              return .inkNormal
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
            standalone
            sizing
            custom
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        InputContent(prefix: .visa, suffix: .checkCircle, state: .default) {
            EmptyView()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack {
            Group {
                InputContent(prefix: .visa, suffix: .checkCircle, state: .default) {
                    Text("Height")
                }

                InputContent(state: .default) {
                    Text("Height")
                }

                InputContent(state: .default) {
                    EmptyView()
                }
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var custom: some View {
        InputContent(prefix: .visa, suffix: .checkCircle, state: .default, message: .error("", icon: .alertCircle)) {
            contentPlaceholder
        }
        .padding(.medium)
        .previewDisplayName()
    }
}

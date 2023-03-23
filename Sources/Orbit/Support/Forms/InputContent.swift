import SwiftUI

/// Content for inputs that share common layout with a prefix and suffix.
struct InputContent<Content: View>: View {

    @Environment(\.idealSize) var idealSize
    @Environment(\.isEnabled) var isEnabled

    public let verticalPadding: CGFloat = .small // = 44 @ normal text size

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

            if idealSize.horizontal == nil {
                Spacer(minLength: 0)
            }

            if let suffixAction = suffixAction {
                suffixIcon
                    .onTapGesture(perform: suffixAction)
                    .accessibility(addTraits: .isButton)
            } else {
                suffixIcon
            }

            TextStrut()
                .padding(.vertical, verticalPadding)
        }
        .foregroundColor(isEnabled ? state.textColor : .cloudDarkActive)
        .background(
            backgroundColor(isPressed: isPressed).animation(.default, value: message)
        )
        .cornerRadius(BorderRadius.default)
        .overlay(border)
    }

    @ViewBuilder var prefixIcon: some View {
        Icon(content: prefix)
            .foregroundColor(prefixColor)
            .padding(.horizontal, .xSmall)
            .padding(.vertical, verticalPadding)
            .accessibility(prefixAccessibilityID)
    }

    @ViewBuilder var suffixIcon: some View {
        Icon(content: suffix)
            .foregroundColor(suffixColor)
            .padding(.horizontal, .xSmall)
            .padding(.vertical, verticalPadding)
            .contentShape(Rectangle())
            .accessibility(suffixAccessibilityID)
    }

    @ViewBuilder var border: some View {
        RoundedRectangle(cornerRadius: BorderRadius.default)
            .strokeBorder(outlineColor(isPressed: isPressed), lineWidth: BorderWidth.active)
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if isEnabled == false {
            return .cloudLight
        }

        switch (state, isPressed) {
            case (.default, true):      return .cloudNormalHover
            case (.default, false):     return .cloudNormal
            case (.modified, true):     return .blueLight
            case (.modified, false):    return .blueLightHover
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
            default:                    return .clear
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
                InputContent(prefix: .visa, suffix: .checkCircle) {
                    Text("InputContent")
                }

                InputContent(state: .modified) {
                    Text("InputContent with a\nvery long value")
                        .padding(.leading, .small)
                        .padding(.vertical, .small)
                }

                InputContent(prefix: .grid) {
                    EmptyView()
                }

                InputContent {
                    contentPlaceholder
                }

                InputContent(message: .error("")) {
                    contentPlaceholder
                }

                InputContent {
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

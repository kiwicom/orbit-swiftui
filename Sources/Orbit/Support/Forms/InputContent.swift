import SwiftUI

/// Content for inputs that share common layout with a prefix and suffix.
struct InputContent<Content: View>: View {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor

    public let verticalPadding: CGFloat = .small // = 44 @ normal text size

    var prefix: Icon.Content?
    var suffix: Icon.Content?
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

            suffixIcon

            TextStrut()
                .padding(.vertical, verticalPadding)
        }
        .textColor(resolvedTextColor)
        .background(
            backgroundColor(isPressed: isPressed).animation(.default, value: message)
        )
        .cornerRadius(BorderRadius.default)
        .overlay(border)
    }

    @ViewBuilder var prefixIcon: some View {
        Icon(prefix)
            .padding(.leading, .small)
            .padding(.trailing, .xSmall)
            .padding(.vertical, verticalPadding)
            .accessibility(prefixAccessibilityID)
            // The component should expose the label as a part of the field primary input or action
            .accessibility(hidden: true)
    }

    @ViewBuilder var suffixIcon: some View {
        suffixContent
            .accessibility(suffixAccessibilityID)
    }

    @ViewBuilder var suffixContent: some View {
        if let suffix {
            if let suffixAction = suffixAction {
                BarButton(suffix, size: .normal) {
                    suffixAction()
                }
                .padding(.trailing, .xxSmall)
                .accessibility(addTraits: .isButton)
            } else {
                Icon(suffix)
                    .padding(.leading, .xSmall)
                    .padding(.trailing, .small)
                    .padding(.vertical, verticalPadding)
                    // The component should expose the label as a part of the field primary input or action
                    .accessibility(hidden: true)
            }
        }
    }

    @ViewBuilder var border: some View {
        RoundedRectangle(cornerRadius: BorderRadius.default)
            .strokeBorder(outlineColor(isPressed: isPressed), lineWidth: BorderWidth.active)
    }

    private var resolvedTextColor: Color {
        isEnabled
            ? textColor ?? state.textColor
            : .cloudDarkActive
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
        VStack(spacing: .medium) {
            InputContent(prefix: .visa, suffix: .checkCircle, state: .modified) {
                EmptyView()
            }
            InputContent(prefix: .visa, suffix: .checkCircle, state: .default, suffixAction: {}) {
                EmptyView()
            }
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

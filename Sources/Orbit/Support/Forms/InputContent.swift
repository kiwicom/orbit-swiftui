import SwiftUI

/// Content for inputs that share common layout with a prefix and suffix.
struct InputContent<Content: View>: View {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isEnabled) private var isEnabled

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
            // The component should expose the label as a part of the field primary input or action
            .accessibility(hidden: true)
    }

    @ViewBuilder var suffixIcon: some View {
        suffixContent
            .foregroundColor(suffixColor)
            .accessibility(suffixAccessibilityID)
    }

    @ViewBuilder var suffixContent: some View {
        if let suffix {
            if let suffixAction = suffixAction {
                BarButton(suffix, size: .normal) {
                    suffixAction()
                }
                .accessibility(addTraits: .isButton)
            } else {
                Icon(content: suffix)
                    .padding(.horizontal, .xSmall)
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
            case .default:              return .inkDark
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
            InputContent(prefix: .visa, suffix: .checkCircle, state: .default) {
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

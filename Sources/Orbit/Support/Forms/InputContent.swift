import SwiftUI

/// Content for inputs that share common layout with a prefix and suffix.
public struct InputContent<Content: View, Prefix: View, Suffix: View>: View {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor

    public let verticalPadding: CGFloat = .small // = 44 @ normal text size

    private let state: InputState
    private let message: Message?
    private let isPressed: Bool
    private let isEditing: Bool
    private let isPlaceholder: Bool
    @ViewBuilder private let content: Content
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix
    
    public var body: some View {
        HStack(spacing: 0) {
            prefix
                .padding(.leading, .small)
                .padding(.trailing, .xSmall)
                .padding(.vertical, verticalPadding)

            content

            if idealSize.horizontal != true {
                Spacer(minLength: 0)
            }

            suffix
                .padding(.leading, .xSmall)
                .padding(.trailing, .small)
                .padding(.vertical, verticalPadding)

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

    @ViewBuilder private var border: some View {
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

    public init(
        state: InputState = .default,
        message: Message? = nil,
        isPressed: Bool = false,
        isEditing: Bool = false,
        isPlaceholder: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self.state = state
        self.message = message
        self.isPressed = isPressed
        self.isEditing = isEditing
        self.isPlaceholder = isPlaceholder
        self.content = content()
        self.prefix = prefix()
        self.suffix = suffix()
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
            InputContent(state: .modified) {
                EmptyView()
            } prefix: {
                Icon(.visa)
            } suffix: {
                Icon(.checkCircle)
            }

            InputContent(state: .default) {
                EmptyView()
            } prefix: {
                Icon(.visa)
            } suffix: {
                IconButton(.checkCircle) {
                    // No action
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack {
            Group {
                InputContent {
                    Text("InputContent")
                } prefix: {
                    Icon(.visa)
                } suffix: {
                    Icon(.checkCircle)
                }

                InputContent {
                    Text("InputContent")
                } prefix: {
                    Icon(.visa)
                } suffix: {
                    Icon(.checkCircle)
                }
                .idealSize()

                InputContent(state: .modified) {
                    Text("InputContent with a\nvery long value")
                        .padding(.leading, .small)
                        .padding(.vertical, .small)
                }

                InputContent {
                    EmptyView()
                } prefix: {
                    Icon(.grid)
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
        InputContent(message: .error("", icon: .alertCircle)) {
            contentPlaceholder
        } prefix: {
            Icon(.visa)
        } suffix: {
            Icon(.checkCircle)
        }
        .padding(.medium)
        .previewDisplayName()
    }
}

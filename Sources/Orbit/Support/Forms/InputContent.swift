import SwiftUI

/// Content for Orbit inputs that share common layout with a prefix and suffix.
public struct InputContent<Content: View, Prefix: View, Suffix: View>: View {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.idealSize) private var idealSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textColor) private var textColor

    public let verticalPadding: CGFloat = .small // = 44 @ normal text size

    private let state: InputState
    private let label: String
    private let message: Message?
    private let isPressed: Bool
    private let isFocused: Bool
    @ViewBuilder private let content: Content
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix
    
    public var body: some View {
        HStack(spacing: 0) {
            prefix
                .iconColor(prefixIconColor)
                .textColor(labelColor)
                .padding(.leading, .small)
                .padding(.trailing, -.xxSmall)
                .padding(.vertical, verticalPadding)

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(label)
                    .padding(.leading, .small)
                    .padding(.trailing, -.xxSmall)
                    .textColor(labelColor)
                    // Component should expose label as part of content
                    .accessibility(hidden: true)
                    .accessibility(removeTraits: .isStaticText)

                content
            }

            if idealSize.horizontal != true {
                Spacer(minLength: 0)
            }

            suffix
                .padding(.leading, -.xxSmall)
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
        .overlay(focusBorder)
        .overlay(border)
    }

    @ViewBuilder private var border: some View {
        RoundedRectangle(cornerRadius: BorderRadius.default)
            .strokeBorder(outlineColor(isPressed: isPressed), lineWidth: BorderWidth.active)
    }

    @ViewBuilder private var focusBorder: some View {
        RoundedRectangle(cornerRadius: 5.5)
            .inset(by: -2)
            .strokeBorder(focusOutlineColor.opacity(0.1), lineWidth: BorderWidth.active)
    }

    private var resolvedTextColor: Color {
        isEnabled
            ? textColor ?? state.textColor
            : .cloudDarkActive
    }

    private var labelColor: Color {
        isEnabled
            ? (textColor ?? .inkNormal)
            : .cloudDarkActive
    }

    private var prefixIconColor: Color? {
        isEnabled
            ? iconColor ?? textColor ?? (label.isEmpty ? .inkDark : .inkNormal)
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
        switch (message, state, isFocused) {
            case (.error, _, _):        return .redNormal
            case (.warning, _, _):      return .orangeNormal
            case (.help, _, _):         return .blueNormal
            case (_, .modified, _):     return .blueDark
            case (_, .default, true):   return .blueNormal
            default:                    return .clear
        }
    }

    private var focusOutlineColor: Color {
        switch (message, isFocused) {
            case (.error, true):        return .redNormal
            case (.warning, true):      return .orangeNormal
            case (.help, true):         return .blueNormal
            case (_, true):             return .blueNormal
            case (_, false):            return .clear
        }
    }

    /// Create content for Orbit inputs that share common layout with a prefix and suffix.
    public init(
        state: InputState = .default,
        label: String = "",
        message: Message? = nil,
        isPressed: Bool = false,
        isFocused: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self.state = state
        self.label = label
        self.message = message
        self.isPressed = isPressed
        self.isFocused = isFocused
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
            InputContent(label: "Label") {
                TextField(value: .constant("Value"))
                    .padding(.horizontal, .small)
            } prefix: {
                Icon(.visa)
            } suffix: {
                Icon(.checkCircle)
            }

            InputContent(isPressed: true) {
                EmptyView()
            } prefix: {
                Icon(.visa)
            } suffix: {
                Icon(.checkCircle)
            }

            InputContent(label: "Label") {
                Text("Value")
                    .padding(.horizontal, .small)
            } suffix: {
                Icon(.checkCircle)
            }

            InputContent(label: "Label") {
                EmptyView()
            } prefix: {
                Icon(.visa)
            } suffix: {
                Icon(.checkCircle)
            }
            .disabled(true)

            InputContent(isPressed: true) {
                EmptyView()
            } prefix: {
                Icon(.visa)
            } suffix: {
                Icon(.checkCircle)
            }

            InputContent(isFocused: true) {
                EmptyView()
            } prefix: {
                Icon(.visa)
            } suffix: {
                Icon(.checkCircle)
            }

            InputContent(message: .error("Error"), isFocused: true) {
                EmptyView()
            } prefix: {
                Icon(.visa)
            } suffix: {
                Icon(.checkCircle)
            }

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

            InputContent(state: .default) {
                headerPlaceholder
            } prefix: {
                CountryFlag("")
            } suffix: {
                EmptyView()
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                InputContent {
                    Text("InputContent")
                        .padding(.horizontal, .small)
                } prefix: {
                    Icon(.visa)
                } suffix: {
                    Icon(.checkCircle)
                }

                InputContent {
                    Text("InputContent")
                        .padding(.horizontal, .small)
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
                .padding(.horizontal, .small)
        } prefix: {
            Icon(.visa)
        } suffix: {
            Icon(.checkCircle)
        }
        .padding(.medium)
        .previewDisplayName()
    }
}

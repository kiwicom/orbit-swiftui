import SwiftUI

/// Offers a label that can optionally be selected and unselected or removed.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tag/)
public struct Tag: View {

    public static let horizontalPadding: CGFloat = .xSmall
    public static let verticalPadding: CGFloat = 6  // Results in ±32 height at normal text size

    @Environment(\.idealSize) var idealSize

    let label: String
    let iconContent: Icon.Content
    let style: Style
    let isFocused: Bool
    let isSelected: Bool
    let isActive: Bool
    let action: () -> Void

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    action()
                },
                label: {
                    HStack(spacing: 0) {
                        if idealSize.horizontal == false {
                            Spacer(minLength: 0)
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Icon(content: iconContent)
                            Text(label, color: nil, weight: .medium)
                                .padding(.vertical, Self.verticalPadding)
                        }
                        .fixedSize(horizontal: true, vertical: false)

                        TextStrut(.normal)
                            .padding(.vertical, Self.verticalPadding)

                        if idealSize.horizontal == false {
                            Spacer(minLength: 0)
                        }
                    }
                }
            )
            .buttonStyle(
                OrbitStyle(style: style, isFocused: isFocused, isSelected: isSelected, isActive: isActive)
            )
        }
    }

    var isEmpty: Bool {
        label.isEmpty && iconContent.isEmpty
    }
}

// MARK: - Inits
public extension Tag {
    
    /// Creates Orbit Tag component.
    init(
        _ label: String = "",
        icon: Icon.Content = .none,
        style: Style = .default,
        isFocused: Bool = true,
        isSelected: Bool = false,
        isActive: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.label = label
        self.iconContent = icon
        self.style = style
        self.isFocused = isFocused
        self.isSelected = isSelected
        self.isActive = isActive
        self.action = action
    }
}

// MARK: - Types
extension Tag {

    public enum Style: Equatable {
        case `default`
        case removable(action: () -> Void = {})

        public static func == (lhs: Tag.Style, rhs: Tag.Style) -> Bool {
            switch (lhs, rhs) {
                case (.default, .default):      return true
                case (.removable, .removable):  return true
                default:                        return false
            }
        }
    }

    public struct OrbitStyle: ButtonStyle {
        let style: Style
        let isFocused: Bool
        let isSelected: Bool
        let isActive: Bool

        public func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: .xSmall) {
                configuration.label
                    .foregroundColor(labelColor)
                    .lineLimit(1)

                if case .removable(let removeAction) = style {
                    Icon(.closeCircle, size: .small, color: iconColor(isPressed: configuration.isPressed))
                        .onTapGesture(perform: removeAction)
                        .accessibility(addTraits: .isButton)
                }
            }
            .foregroundColor(labelColor)
            .padding(.horizontal, Tag.horizontalPadding)
            .background(
                backgroundColor(isPressed: configuration.isPressed)
                    .animation(nil)
            )
            .cornerRadius(BorderRadius.default)
        }

        var labelColor: Color {
            switch (isFocused, isSelected) {
                case (_, true):                 return .whiteNormal
                case (true, false):             return .blueDarker
                case (false, false):            return .inkDark
            }
        }

        /// Creates ButtonStyle matching Orbit Tag component.
        public init(
            style: Style,
            isFocused: Bool,
            isSelected: Bool,
            isActive: Bool = false
        ) {
            self.style = style
            self.isFocused = isFocused
            self.isSelected = isSelected
            self.isActive = isActive
        }

        func backgroundColor(isPressed: Bool) -> Color {
            switch (isFocused, isSelected, isPressed || isActive) {
                case (true, false, false):      return .blueLight
                case (true, true, false):       return .blueNormal
                case (false, false, false):     return .cloudNormal
                case (false, true, false):      return .inkLightHover
                // Pressed
                case (true, false, true):       return .blueLightActive
                case (true, true, true):        return .blueNormalActive
                case (false, false, true):      return .cloudNormalActive
                case (false, true, true):       return .inkNormalHover
            }
        }

        func iconColor(isPressed: Bool) -> Color {
            switch (isSelected, isFocused, isPressed || isActive) {
                case (true, _, _):              return .whiteNormal
                case (false, true, false):      return .blueDarker.opacity(0.3)
                case (false, false, false):     return .inkDark.opacity(0.3)
                // Pressed
                case (false, true, true):       return .blueDarker
                case (false, false, true):      return .inkDark
            }
        }
    }
}

// MARK: - Previews
struct TagPreviews: PreviewProvider {

    static let label = "Prague"

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneExpanding
            styles
            sizing
        }
        .padding(.medium)
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(initialState: true) { state in
            Tag(label, icon: .grid, style: .removable(), isSelected: state.wrappedValue) { state.wrappedValue.toggle() }
            Tag("") // EmptyView
        }
        .previewDisplayName()
    }

    static var standaloneExpanding: some View {
        StateWrapper(initialState: true) { state in
            Tag(label, icon: .grid, style: .removable(), isSelected: state.wrappedValue) { state.wrappedValue.toggle() }
                .idealSize(horizontal: false)
        }
        .previewDisplayName()
    }

    @ViewBuilder static var styles: some View {
        VStack(alignment: .leading, spacing: .large) {
            stack(style: .default, isFocused: true)
            stack(style: .default, isFocused: false)
            stack(style: .removable(), isFocused: true)
            stack(style: .removable(), isFocused: false)
            Separator()
            stack(style: .default, isFocused: false, idealWidth: false)
            stack(style: .removable(), isFocused: true, idealWidth: false)
            Separator()
            HStack(spacing: .medium) {
                StateWrapper(initialState: true) { state in
                    Tag(label, icon: .sort, style: .removable(), isSelected: state.wrappedValue) { state.wrappedValue.toggle() }
                }
                StateWrapper(initialState: false) { state in
                    Tag(icon: .notificationAdd, isFocused: false, isSelected: state.wrappedValue) { state.wrappedValue.toggle() }
                }
            }
        }
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .large) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Button("Button small height \(state.wrappedValue)", size: .small)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Tag("Tag height \(state.wrappedValue)")
                }
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        styles
            .padding(.medium)
    }

    @ViewBuilder static func stack(style: Tag.Style, isFocused: Bool, idealWidth: Bool? = nil) -> some View {
        HStack(spacing: .medium) {
            VStack(spacing: .small) {
                tag(style: style, isFocused: isFocused, isSelected: false, isActive: false)
                tag(style: style, isFocused: isFocused, isSelected: true, isActive: false)
            }

            VStack(spacing: .small) {
                tag(style: style, isFocused: isFocused, isSelected: false, isActive: true)
                tag(style: style, isFocused: isFocused, isSelected: true, isActive: true)
            }
        }
        .idealSize(horizontal: idealWidth)
    }

    @ViewBuilder static func tag(style: Tag.Style, isFocused: Bool, isSelected: Bool, isActive: Bool) -> some View {
        StateWrapper(initialState: (style, isSelected, true)) { state in
            Tag(
                label,
                style: style == .default ? .default : .removable(action: { state.wrappedValue.2 = false }),
                isFocused: isFocused,
                isSelected: state.wrappedValue.1,
                isActive: isActive
            ) {
                state.wrappedValue.1.toggle()
            }
            .disabled(isActive)
            .opacity(state.wrappedValue.2 ? 1 : 0)
        }
    }
}

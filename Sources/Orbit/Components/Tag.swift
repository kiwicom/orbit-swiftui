import SwiftUI

/// Offers a label that can optionally be selected and unselected or removed.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tag/)
/// - Important: Component can expand horizontally by using `idealSize` modifier.
public struct Tag: View {

    public static let horizontalPadding: CGFloat = .xSmall
    public static let verticalPadding: CGFloat = 6 // = 32 height @ normal size text size

    @Environment(\.idealSize) var idealSize

    let label: String
    let iconContent: Icon.Content
    let style: Style
    let isFocused: Bool
    let isActive: Bool
    @Binding var isSelected: Bool

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    isSelected.toggle()
                },
                label: {
                    HStack(spacing: 0) {
                        if idealSize.horizontal == false {
                            Spacer(minLength: 0)
                        }

                        HStack(spacing: 6) {
                            Icon(content: iconContent, size: Text.Size.normal.iconSize)
                                .fontWeight(.medium)
                            
                            Text(label)
                                .foregroundColor(nil)
                                .fontWeight(.medium)
                        }
                        .fixedSize(horizontal: true, vertical: false)

                        if idealSize.horizontal == false {
                            Spacer(minLength: 0)
                        }
                    }
                    .padding(.vertical, Self.verticalPadding)
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
        isActive: Bool = false,
        isSelected: Binding<Bool>
    ) {
        self.init(
            label: label,
            iconContent: icon,
            style: style,
            isFocused: isFocused,
            isActive: isActive,
            isSelected: isSelected
        )
    }
}

// MARK: - Types
extension Tag {

    public enum Style: Equatable {
        case `default`
        case removable(action: () -> Void)

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
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(true) { isSelected in
            Tag(label, icon: .grid, style: .removable(action: {}), isSelected: isSelected)
            Tag("", isSelected: .constant(false)) // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var standaloneExpanding: some View {
        StateWrapper(true) { isSelected in
            Tag(label, icon: .grid, style: .removable(action: {}), isSelected: isSelected)
                .idealSize(horizontal: false)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(alignment: .leading, spacing: .large) {
            stack(style: .default, isFocused: true)
            stack(style: .default, isFocused: false)
            stack(style: .removable(action: {}), isFocused: true)
            stack(style: .removable(action: {}), isFocused: false)
            Separator()
            stack(style: .default, isFocused: false, idealWidth: false)
            stack(style: .removable(action: {}), isFocused: true, idealWidth: false)
            Separator()
            HStack(spacing: .medium) {
                StateWrapper(true) { isSelected in
                    Tag(label, icon: .sort, style: .removable(action: {}), isSelected: isSelected)
                }
                StateWrapper(false) { isSelected in
                    Tag(icon: .notificationAdd, isFocused: false, isSelected: isSelected)
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .trailing, spacing: .large) {
            Group {
                Tag("Tag", isFocused: false, isSelected: .constant(false))
                Tag("Tag", icon: .grid, isFocused: false, isSelected: .constant(false))
                Tag(icon: .grid, isFocused: false, isSelected: .constant(false))
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func stack(style: Tag.Style, isFocused: Bool, idealWidth: Bool? = nil) -> some View {
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

    static func tag(style: Tag.Style, isFocused: Bool, isSelected: Bool, isActive: Bool) -> some View {
        StateWrapper((style, isSelected, true)) { state in
            Tag(
                label,
                style: style == .default ? .default : .removable(action: { state.wrappedValue.2 = false }),
                isFocused: isFocused,
                isActive: isActive,
                isSelected: state.1
            )
            .disabled(isActive)
            .opacity(state.wrappedValue.2 ? 1 : 0)
        }
    }
}

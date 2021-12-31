import SwiftUI

/// Offers a label that can optionally be selected and unselected or removed.
///
/// - Related components:
///   - ``Badge``
///   - ``Button``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tag/)
public struct Tag: View {

    public static let height = Spacing.xLarge
    public static let minWidth = Spacing.xLarge

    let label: String
    let isSelected: Bool
    let style: Style
    let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                Text(label, color: nil, weight: .medium)
                    .fixedSize()
            }
        )
        .buttonStyle(OrbitStyle(isSelected: isSelected, style: style))
    }
}

// MARK: - Inits
public extension Tag {
    
    /// Creates Orbit Tag component.
    init(_ label: String, isSelected: Bool = false, style: Style = .default, action: @escaping () -> Void = {}) {
        self.label = label
        self.isSelected = isSelected
        self.style = style
        self.action = action
    }
}

// MARK: - Types
extension Tag {

    public enum Style {
        case `default`
        case removable(action: () -> Void = {})
    }

    struct OrbitStyle: ButtonStyle {
        let isSelected: Bool
        let style: Style

        func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: .xSmall) {
                configuration.label
                    .foregroundColor(labelColor)
                    .lineLimit(1)

                if case .removable(let removeAction) = style {
                    Icon(.closeCircle, size: .small, color: iconColor(isPressed: configuration.isPressed))
                        .onTapGesture(perform: removeAction)
                }
            }
            .foregroundColor(labelColor)
            .frame(minWidth: Tag.minWidth)
            .padding(.horizontal, .xSmall)
            .frame(height: Tag.height)
            .background(
                backgroundColor(isPressed: configuration.isPressed)
                    .animation(nil)
            )
            .cornerRadius(BorderRadius.default)
        }

        var labelColor: Color {
            switch (style, isSelected) {
                case (.default, false):             return .inkNormal
                case (.removable, false):           return .blueDarker
                case (_, _):                        return .white
            }
        }

        func backgroundColor(isPressed: Bool) -> Color {
            switch (style, isSelected, isPressed) {
                case (.default, false, false):      return .cloudDark
                case (.default, false, true):       return .cloudNormalActive
                case (.removable, false, false):    return .blueLight
                case (.removable, false, true):     return .blueLightActive
                case (_, true, false):              return .blueNormal
                case (_, true, true):               return .blueNormalActive
            }
        }

        func iconColor(isPressed: Bool) -> Color {
            switch (isSelected, isPressed) {
                case (false, false):                return .blueDarker.opacity(0.3)
                case (false, true):                 return .blueDarker
                case (true, false):                 return .white.opacity(0.6)
                case (true, true):                  return .white
            }
        }
    }
}

// MARK: - Previews
struct TagPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone

            snapshots
                .previewDisplayName("Tags")
        }
        .previewLayout(PreviewLayout.sizeThatFits)

        PreviewWrapperWithState(initialState: false) { state in
            Tag("Tag", isSelected: state.wrappedValue) { state.wrappedValue.toggle() }
                .previewDisplayName("Live Preview")

            Tag("Removable Tag", isSelected: state.wrappedValue, style: .removable()) {
                state.wrappedValue.toggle()
            }
            .previewDisplayName("Live Preview - Removable")
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        PreviewWrapperWithState(initialState: true) { state in
            Tag("Label", isSelected: state.wrappedValue) { state.wrappedValue.toggle() }
        }
    }

    @ViewBuilder static var orbit: some View {
        HStack(spacing: .large) {
            Tag("Prague", isSelected: false)
            Tag("Prague", isSelected: false, style: .removable())
        }
        HStack(spacing: .large) {
            Tag("Prague", isSelected: true)
            Tag("Prague", isSelected: true, style: .removable())
        }
    }

    static var snapshots: some View {
        VStack(spacing: .small) {
            orbit
        }
        .frame(width: 180)
        .padding(.vertical)
    }
}

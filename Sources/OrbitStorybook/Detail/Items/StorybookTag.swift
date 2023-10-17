import SwiftUI
import Orbit

struct StorybookTag {

    static let label = "Prague"

    @ViewBuilder static var basic: some View {
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
        .previewDisplayName()
    }

    @ViewBuilder static func stack(style: TagStyle, isFocused: Bool, idealWidth: Bool? = nil) -> some View {
        HStack(spacing: .medium) {
            VStack(spacing: .small) {
                tag(style: style, isFocused: isFocused, isSelected: false)
                tag(style: style, isFocused: isFocused, isSelected: true)
            }
        }
        .idealSize(horizontal: idealWidth)
    }

    @ViewBuilder static func tag(style: TagStyle, isFocused: Bool, isSelected: Bool) -> some View {
        StateWrapper((style, isSelected, true)) { state in
            Tag(
                label,
                style: style == .default ? .default : .removable(action: { state.wrappedValue.2 = false }),
                isFocused: isFocused,
                isSelected: state.1
            )
            .opacity(state.wrappedValue.2 ? 1 : 0)
        }
    }
}

struct StorybookTagPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTag.basic
        }
    }
}

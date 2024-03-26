import SwiftUI
import Orbit

struct StorybookTag {

    static let label = "Prague"

    @ViewBuilder static var basic: some View {
        VStack(alignment: .leading, spacing: .large) {
            stack(isRemovable: false, isFocused: true)
            stack(isRemovable: false, isFocused: false)
            stack(isRemovable: true, isFocused: true)
            stack(isRemovable: true, isFocused: false)
            Separator()
            stack(isRemovable: false, isFocused: false, idealWidth: false)
            stack(isRemovable: true, isFocused: true, idealWidth: false)
            Separator()
            HStack(spacing: .medium) {
                StateWrapper(true) { isSelected in
                    Tag(label, icon: .sort, isSelected: isSelected, removeAction: {})
                }
                StateWrapper(false) { isSelected in
                    Tag(icon: .notificationAdd, isFocused: false, isSelected: isSelected)
                }
            }
        }
        .previewDisplayName()
    }

    static func stack(isRemovable: Bool, isFocused: Bool, idealWidth: Bool? = nil) -> some View {
        HStack(spacing: .medium) {
            VStack(spacing: .small) {
                tag(isRemovable: isRemovable, isFocused: isFocused, isSelected: false)
                tag(isRemovable: isRemovable, isFocused: isFocused, isSelected: true)
            }
        }
        .idealSize(horizontal: idealWidth)
    }

    static func tag(isRemovable: Bool, isFocused: Bool, isSelected: Bool) -> some View {
        StateWrapper((isRemovable, isSelected, true)) { state in
            Tag(
                label,
                isFocused: isFocused,
                isSelected: state.1,
                removeAction: state.0.wrappedValue ? { state.wrappedValue.2 = false } : nil
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

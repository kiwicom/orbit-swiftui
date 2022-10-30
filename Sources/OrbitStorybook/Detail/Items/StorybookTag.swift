import SwiftUI
import Orbit

struct StorybookTag {

    static let label = "Prague"

    @ViewBuilder static var basic: some View {
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

struct StorybookTagPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTag.basic
        }
    }
}

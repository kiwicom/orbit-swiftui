import SwiftUI

/// Orbit component that displays a control that can be selected, unselected, or removed.
///
/// A ``Tag`` consists of a label, icon and optional removable action.
///
/// ```swift
/// Tag("Sorting", icon: .sort, isSelected: $isSortingApplied)
/// Tag("Filters", isSelected: $isFiltersApplied) {
///    // Tap action
/// }
/// ```
/// 
/// ### Customizing appearance
///
/// The label and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
///
/// ```swift
/// Tag("Selected", isSelected: $isSelected)
///     .textColor(.blueLight)
///     .iconColor(.blueNormal)
/// ```
///
/// Before the action is triggered, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component does not expand horizontally, unless forced by the native ``idealSize()`` modifier with a `false` value.
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/tag/)
public struct Tag<Icon: View>: View, PotentiallyEmptyView {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let label: String
    private let isFocused: Bool
    @Binding private var isSelected: Bool
    @ViewBuilder private let icon: Icon
    private let removeAction: (() -> Void)?

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                isSelected.toggle()
            } label: {
                HStack(spacing: 0) {
                    if idealSize.horizontal == false {
                        Spacer(minLength: 0)
                    }
                    
                    HStack(spacing: 6) {
                        icon
                            .font(.system(size: Text.Size.normal.value))
                        
                        Text(label)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    if idealSize.horizontal == false {
                        Spacer(minLength: 0)
                    }
                }
            }
            .buttonStyle(
                TagButtonStyle(isFocused: isFocused, isSelected: isSelected, removeAction: removeAction)
            )
            .accessibility(addTraits: isSelected ? .isSelected : [])
        }
    }

    var isEmpty: Bool {
        label.isEmpty && icon.isEmpty
    }
}

// MARK: - Inits
public extension Tag {

    /// Creates Orbit ``Tag`` component with custom leading icon.
    init(
        _ label: String = "",
        isFocused: Bool = true,
        isSelected: Binding<Bool>,
        @ViewBuilder icon: () -> Icon,
        removeAction: (() -> Void)? = nil
    ) {
        self.label = label
        self.isFocused = isFocused
        self._isSelected = isSelected
        self.icon = icon()
        self.removeAction = removeAction
    }

    /// Creates Orbit ``Tag`` component.
    init(
        _ label: String = "",
        icon: Icon.Symbol? = nil,
        isFocused: Bool = true,
        isSelected: Binding<Bool>,
        removeAction: (() -> Void)? = nil
    ) where Icon == Orbit.Icon {
        self.init(
            label,
            isFocused: isFocused,
            isSelected: isSelected,
            icon: {
                Icon(icon)
                    .iconSize(textSize: .normal)
            },
            removeAction: removeAction
        )
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
            Tag(label, icon: .grid, isSelected: isSelected, removeAction: {})
            Tag("", isSelected: .constant(false)) // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var standaloneExpanding: some View {
        StateWrapper(true) { isSelected in
            Tag(label, icon: .grid, isSelected: isSelected, removeAction: {})
                .idealSize(horizontal: false)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
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

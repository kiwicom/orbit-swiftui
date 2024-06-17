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
public struct Tag<Label: View, Icon: View>: View, PotentiallyEmptyView {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let isFocused: Bool
    private let isRemovable: Bool
    @Binding private var isSelected: Bool
    private let removeAction: (() -> Void)?
    @ViewBuilder private let label: Label
    @ViewBuilder private let icon: Icon

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
                            .iconSize(textSize: .normal)
                            .font(.system(size: Text.Size.normal.value))
                        
                        label
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    if idealSize.horizontal == false {
                        Spacer(minLength: 0)
                    }
                }
            }
            .buttonStyle(
                TagButtonStyle(
                    isFocused: isFocused, 
                    isSelected: isSelected, 
                    isRemovable: isRemovable, 
                    removeAction: removeAction
                )
            )
            .accessibility(addTraits: isSelected ? .isSelected : [])
        }
    }

    var isEmpty: Bool {
        label.isEmpty && icon.isEmpty
    }
    
    /// Creates Orbit ``Tag`` component with custom content.
    public init(
        isFocused: Bool = true,
        isSelected: Binding<Bool>,
        isRemovable: Bool = false,
        removeAction: (() -> Void)? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.isFocused = isFocused
        self._isSelected = isSelected
        self.isRemovable = isRemovable
        self.removeAction = removeAction
        self.label = label()
        self.icon = icon()
    }
}

// MARK: - Convenience Inits
public extension Tag where Label == Text, Icon == Orbit.Icon {

    /// Creates Orbit ``Tag`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol,
        icon: Icon.Symbol? = nil,
        isFocused: Bool = true,
        isSelected: Binding<Bool>,
        isRemovable: Bool = false,
        removeAction: (() -> Void)? = nil
    ) {
        self.init(
            isFocused: isFocused,
            isSelected: isSelected,
            isRemovable: isRemovable,
            removeAction: removeAction
        ) {
            Text(label)
        } icon: {
            Icon(icon)
        }
    }
    
    /// Creates Orbit ``Tag`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        isFocused: Bool = true,
        isSelected: Binding<Bool>,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        removeAction: (() -> Void)? = nil
    ) {
        self.init(
            isFocused: isFocused,
            isSelected: isSelected,
            removeAction: removeAction
        ) {
            Text(label, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
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
                    Tag(label, icon: .sort, isSelected: isSelected, isRemovable: true, removeAction: {})
                }
                StateWrapper(false) { isSelected in
                    Tag("", icon: .notificationAdd, isFocused: false, isSelected: isSelected)
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
                Tag("", icon: .grid, isFocused: false, isSelected: .constant(false))
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
                isRemovable: true,
                removeAction: state.0.wrappedValue ? { state.wrappedValue.2 = false } : nil
            )
            .opacity(state.wrappedValue.2 ? 1 : 0)
        }
    }
}

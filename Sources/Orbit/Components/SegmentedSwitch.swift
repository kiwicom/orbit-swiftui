import SwiftUI

/// Showing two choices from which only one can be selected.
///
/// Currently SegmentedSwitch allows to have 2 segments.
/// SegmentedSwitch can be in error state only in unselected state.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/segmentedswitch/)
public struct SegmentedSwitch<Selection: Hashable, Content: View>: View {

    @Environment(\.colorScheme) private var colorScheme
    @Binding private var selection: Selection?
    let label: String
    let message: Message?
    let content: Content

    let borderWidth: CGFloat = BorderWidth.active

    public var body: some View {
        FieldWrapper(label, message: message) {
            InputContent(message: message) {
                content
                    .environment(\.segmentSelection, selectionBinding)
                    .overlay(separator)
                    .backgroundPreferenceValue(IDPreferenceKey.self) { preference in
                        selectionBackground(preference)
                    }
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(selection.map(String.init(describing:)) ?? ""))
        .accessibility(hint: .init(accessibilityHint))
        .accessibility(addTraits: .isButton)
        .accessibility(addTraits: selection != nil ? .isSelected : [])
    }

    @ViewBuilder var separator: some View {
        (selection == nil ? borderColor : .clear)
            .frame(width: borderWidth)
            .frame(maxHeight: .infinity)
            .padding(.vertical, BorderWidth.active)
    }

    @ViewBuilder func selectionBackground(_ preference: IDPreferenceKey.Value) -> some View {
        HStack(spacing: 0) {
            if let anchor = preference.first(where: { $0.id == selection.map(AnyHashable.init) })?.bounds {
                GeometryReader { geometry in
                    let itemWidth = geometry.size.width / 2

                    background
                        .frame(width: itemWidth)
                        .offset(x: (geometry[anchor].minX / itemWidth).rounded(.down) * itemWidth)
                }
            } else {
                background
            }
        }
        .animation(.easeOut(duration: 0.2), value: selection)
    }

    @ViewBuilder var background: some View {
        (colorScheme == .light ? Color.whiteDarker : Color.cloudDarkActive)
            .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
            .padding(borderWidth)
            .elevation(selection != nil ? .level1 : nil)
    }

    private var selectionBinding: Binding<AnyHashable?> {
        Binding(
           get: { selection.map(AnyHashable.init) },
           set: { selection = $0?.base as? Selection }
        )
    }

    private var borderColor: Color {
        message?.status?.color ?? .cloudNormal
    }

    private var accessibilityHint: String {
        message?.description ?? ""
    }
    
    public init(
        _ label: String = "",
        selection: Binding<Selection?>,
        message: Message? = nil,
        @SegmentedSwitchContentBuilder content: () -> Content
    ) {
        self.label = label
        self._selection = selection
        self.message = message
        self.content = content()
    }
}

public extension AccessibilityID {
    static let segmentedSwitchFirstOption = Self(rawValue: "orbit.segmentedswitch.first")
    static let segmentedSwitchSecondOption = Self(rawValue: "orbit.segmentedswitch.second")
}

// MARK: - Types

/// A view builder for constructing `SegmentedSwitch` content.
@resultBuilder public enum SegmentedSwitchContentBuilder {

    static let verticalTextPadding: CGFloat = .small // = 44 @ normal text size

    public static func buildBlock(_ first: some View, _ second: some View) -> some View {
        HStack(spacing: 0) {
            switchItem {
                first
                    .accessibility(.segmentedSwitchFirstOption)
            }

            TextStrut()
                .padding(.vertical, Self.verticalTextPadding)

            switchItem {
                second
                    .accessibility(.segmentedSwitchSecondOption)
            }
        }
     }

    @ViewBuilder static func switchItem(content: @escaping () -> some View) -> some View {
        EnvironmentReader(\.segmentSelection) { selection in
            PreferenceReader(IDPreferenceKey.self) { preference in
                content()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, .small)
                    .padding(.vertical, verticalTextPadding)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection.wrappedValue = preference.first?.id
                    }
            }
        }
    }
}

struct SegmentSelectionKey: EnvironmentKey {
    static let defaultValue: Binding<AnyHashable?> = .constant(nil)
}

extension EnvironmentValues {
    var segmentSelection: Binding<AnyHashable?> {
        get { self[SegmentSelectionKey.self] }
        set { self[SegmentSelectionKey.self] = newValue }
    }
}

// MARK: - Previews
struct SegmentedSwitchPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            unselected
            sizing
            selected
            help
            error
            interactive
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var unselected: some View {
        segmentedSwitch()
            .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            segmentedSwitch(selection: nil, label: "")
                .measured()
            segmentedSwitch(selection: .female, label: "")
                .measured()
            segmentedSwitch(selection: .female, secondOption: "Multiline\nOption", label: "")
                .measured()
        }
        .previewDisplayName()
    }

    static var selected: some View {
        segmentedSwitch(selection: .male)
            .previewDisplayName()
    }

    static var help: some View {
        segmentedSwitch(message: .help("Help message"))
            .previewDisplayName()
    }

    static var error: some View {
        segmentedSwitch(message: .error("Error message"))
            .previewDisplayName()
    }

    static var interactive: some View {
        StateWrapper(Gender?.some(.male)) { value in
            VStack(spacing: .large) {
                SegmentedSwitch("Gender\nmultiline", selection: value) {
                    Text("Male with long name")
                        .identifier(Gender.male)

                    Text("Female with much longer name")
                        .identifier(Gender.female)
                }
                Text(value.wrappedValue.map(String.init(describing:)) ?? "")
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(spacing: .xMedium) {
            unselected
            selected
            help
            error
        }
        .padding(.medium)
    }

    enum Gender {
        case male
        case female
    }

    static func segmentedSwitch(
        selection: Gender? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        label: String = "Gender",
        message: Message? = nil
    ) -> some View {
        StateWrapper(selection) { value in
            SegmentedSwitch(label, selection: value, message: message) {
                Text(firstOption)
                    .identifier(Gender.male)

                Text(secondOption)
                    .identifier(Gender.female)
            }
            .multilineTextAlignment(.center)
        }
    }
}

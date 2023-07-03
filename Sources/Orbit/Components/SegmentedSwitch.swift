import SwiftUI

/// Showing choices from which only one can be selected.
///
/// Specify two, or at most, three views in the content closure,
/// giving each an `.identifier` that matches a value
/// of the selection binding:
///
/// ```
/// enum Direction {
///     case left
///     case right
/// }
///
/// @State var direction: Direction?
///
/// SegmentedSwitch(selection: $direction) {
///     Text("Left")
///         .identifier(Direction.left)
///     Text("Right")
///         .identifier(Direction.right)
/// }
/// ```
///
/// SegmentedSwitch can be in error state only in unselected state.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/segmentedswitch/)
public struct SegmentedSwitch<Selection: Hashable, Content: View>: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.idealSize) private var idealSize
    @Binding private var selection: Selection?
    let label: String
    let message: Message?
    let content: Content

    let borderWidth: CGFloat = BorderWidth.active
    let horizontalPadding: CGFloat = .small

    public var body: some View {
        FieldWrapper(label, message: message) {
            InputContent(message: message) {
                HStack(spacing: borderWidth) {
                    content
                        .allowsHitTesting(false)
                        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.vertical, .small) // = 44 @ normal text size
                        .multilineTextAlignment(.center)
                }
                .backgroundPreferenceValue(IDPreferenceKey.self) { preferences in
                    selectedSegmentButton(preferences: preferences)
                }
                .backgroundPreferenceValue(IDPreferenceKey.self) { preferences in
                    unselectedSegmentButtons(preferences)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibility(label: .init(label))
        .accessibility(hint: .init(message?.description ?? ""))
    }

    @ViewBuilder func selectedSegmentButton(preferences: [IDPreference]) -> some View {
        if let index = preferences.firstIndex(where: isSelected) {
            segmentButton(preferences: preferences, index: index) {
                segmentBackground
                    .elevation(.level1)
            }
            .animation(.easeOut(duration: 0.2), value: selection)
        }
    }

    @ViewBuilder func unselectedSegmentButtons(_ preferences: [IDPreference]) -> some View {
        ForEach(unselectedPreferences(preferences), id: \.1.id) { index, preference in
            segmentButton(preferences: preferences, index: index) {
                Color.cloudNormal
            }
        }
        .overlay(
            noSelectionBackground(preferences)
        )
        .animation(.easeOut(duration: 0.2), value: selection)
    }

    @ViewBuilder func segmentButton(
        preferences: [IDPreference],
        index: Int,
        @ViewBuilder label: @escaping () -> some View
    ) -> some View {
        let preference = preferences[index]
        let isSelected = isSelected(preference)

        GeometryReader { geometry in
            let (width, minX) = measurements(
                index: index,
                preferences: preferences,
                idealSize: isIdealSize,
                horizontalPadding: horizontalPadding,
                separatorWidth: borderWidth,
                in: geometry
            )

            SwiftUI.Button {
                selection = selection(from: preference)
            } label: {
                label()
            }
            .buttonStyle(.backgroundHighlight(isActive: isSelected, borderWidth: borderWidth, pressedOpacity: 0.4))
            .frame(width: width)
            .offset(x: minX)
            .accessibility(value: .init((selection(from: preference)).map(String.init(describing:)) ?? ""))
            .accessibility(addTraits: isSelected ? .isSelected : [])
        }
    }

    @ViewBuilder func noSelectionBackground(_ preferences: [IDPreference]) -> some View {
        if selection == nil {
            GeometryReader { geometry in
                segmentBackground
                    .overlay(
                        ForEach(1..<preferences.count, id: \.self) { index in
                            separator
                                .offset(
                                    x: measurements(
                                        index: index,
                                        preferences: preferences,
                                        idealSize: isIdealSize,
                                        horizontalPadding: horizontalPadding,
                                        separatorWidth: borderWidth,
                                        in: geometry
                                    ).minX
                                )
                        },
                        alignment: .leading
                    )
                    .allowsHitTesting(false)
            }
        }
    }

    @ViewBuilder var segmentBackground: some View {
        (colorScheme == .light ? Color.whiteDarker : Color.cloudDarkActive)
            .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
            .padding(borderWidth)
    }

    @ViewBuilder var separator: some View {
        (message?.status?.color ?? .cloudNormal)
            .frame(width: borderWidth)
            .frame(maxHeight: .infinity)
            .padding(.vertical, borderWidth)
    }

    private func unselectedPreferences(_ preferences: [IDPreference]) -> [(Int, IDPreference)] {
        preferences.enumerated().filter { isSelected($0.element) == false }
    }

    private func isSelected(_ preference: IDPreference) -> Bool {
        selection == selection(from: preference)
    }

    private func selection(from preference: IDPreference) -> Selection? {
        preference.id.base as? Selection
    }

    private var isIdealSize: Bool {
        idealSize.horizontal == true
    }
    
    public init(
        _ label: String = "",
        selection: Binding<Selection?>,
        message: Message? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self._selection = selection
        self.message = message
        self.content = content()
    }

    public init(
        _ label: String = "",
        selection: Binding<Selection>,
        message: Message? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            label,
            selection: .init(
                get: { selection.wrappedValue },
                set: { newValue in newValue.map { selection.wrappedValue = $0 } }
            ),
            message: message,
            content: content
        )
    }
}

private func measurements(
    index: Int,
    preferences: [IDPreference],
    idealSize: Bool,
    horizontalPadding: CGFloat,
    separatorWidth: CGFloat,
    in geometry: GeometryProxy
) -> (width: CGFloat, minX: CGFloat) {
    if idealSize {
        let minX = preferences.prefix(upTo: index).reduce(into: 0) { finalMinX, preference in
            finalMinX += geometry[preference.bounds].width + separatorWidth + horizontalPadding * 2
        }
        let width = geometry[preferences[index].bounds].width + horizontalPadding * 2

        return (width, minX)
    } else {
        let width = geometry.size.width / CGFloat(preferences.count)
        let minX = (geometry[preferences[index].bounds].minX / width).rounded(.down) * width

        return (width, minX)
    }
}

// MARK: - Previews
struct SegmentedSwitchPreviews: PreviewProvider {

    enum Gender {
        case male
        case female
        case nonBinary
    }

    static var previews: some View {
        PreviewWrapper {
            unselected
            sizing
            selected
            help
            error
            interactive
            threeOptions
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var unselected: some View {
        binarySegmentedSwitch()
            .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            binarySegmentedSwitch(selection: nil, label: "")
                .measured()
            binarySegmentedSwitch(selection: .female, label: "")
                .measured()
            binarySegmentedSwitch(selection: .female, secondOption: "Multiline\nOption", label: "")
                .measured()
            binarySegmentedSwitch(selection: .female, label: "")
                .idealSize()
                .measured()
            threeOptionsSegmentedSwitch(selection: nil, label: "")
                .measured()
            threeOptionsSegmentedSwitch(selection: .female, label: "")
                .measured()
            threeOptionsSegmentedSwitch(selection: nil, label: "")
                .idealSize()
                .measured()
            threeOptionsSegmentedSwitch(selection: .female, label: "")
                .idealSize()
                .measured()
            threeOptionsSegmentedSwitch(selection: .female, thirdOption: "Non\nbinary", label: "")
                .idealSize()
                .measured()
        }
        .previewDisplayName()
    }

    static var selected: some View {
        binarySegmentedSwitch(selection: .male)
            .previewDisplayName()
    }

    static var help: some View {
        binarySegmentedSwitch(message: .help("Help message"))
            .previewDisplayName()
    }

    static var error: some View {
        binarySegmentedSwitch(message: .error("Error message"))
            .previewDisplayName()
    }

    static var threeOptions: some View {
        threeOptionsSegmentedSwitch()
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

    static func binarySegmentedSwitch(
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
        }
    }

    static func threeOptionsSegmentedSwitch(
        selection: Gender? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        thirdOption: String = "Non binary",
        label: String = "Gender",
        message: Message? = nil
    ) -> some View {
        StateWrapper(selection) { value in
            SegmentedSwitch(label, selection: value, message: message) {
                Text(firstOption)
                    .identifier(Gender.male)

                Text(secondOption)
                    .identifier(Gender.female)

                Text(thirdOption)
                    .identifier(Gender.nonBinary)
            }
        }
    }
}

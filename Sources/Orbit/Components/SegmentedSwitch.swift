import SwiftUI

/// Showing two choices from which only one can be selected.
///
/// Currently SegmentedSwitch allows to have 2 segments.
/// SegmentedSwitch can be in error state only in unselected state.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/segmentedswitch/)
public struct SegmentedSwitch<Selection: Hashable, Content: View>: View {

    let verticalTextPadding: CGFloat = .small // = 44 @ normal text size

    @Environment(\.colorScheme) private var colorScheme
    @Binding private var selection: Selection?
    let label: String
    let message: Message?
    let content: Content

    let borderWidth: CGFloat = BorderWidth.active

    public var body: some View {
        FieldWrapper(label, message: message) {
            InputContent(message: message) {
                HStack(spacing: 0) {
                    content
                        .allowsHitTesting(false)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, .small)
                        .padding(.vertical, verticalTextPadding)
                }
                .backgroundPreferenceValue(IDPreferenceKey.self) { preference in
                    interactionBackground(preference)
                }
                .backgroundPreferenceValue(IDPreferenceKey.self) { preference in
                    selectionBackground(preference)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibility(label: .init(label))
        .accessibility(hint: .init(message?.description ?? ""))
    }

    @ViewBuilder func interactionBackground(_ preferences: [IDPreference]) -> some View {
        GeometryReader { geometry in
            ForEach(Array(preferences.enumerated()), id: \.element.id) { index, preference in
                Color.clear
                    .contentShape(Rectangle())
                    .segmentFrame(bounds: preference.bounds, in: geometry)
                    .onTapGesture {
                        selection = selection(from: preference)
                    }
                    .accessibility(index == 0 ? .segmentedSwitchFirstOption : .segmentedSwitchSecondOption)
                    .accessibility(value: .init((selection(from: preference)).map(String.init(describing:)) ?? ""))
                    .accessibility(addTraits: .isButton)
                    .accessibility(addTraits: isSelected(preference) ? .isSelected : [])
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        selection = selection(at: value.location, preferences: preferences, in: geometry)
                    }
            )
        }
    }

    @ViewBuilder func selectionBackground(_ preferences: [IDPreference]) -> some View {
        HStack(spacing: 0) {
            if let bounds = preferences.first(where: isSelected)?.bounds {
                GeometryReader { geometry in
                    background
                        .segmentFrame(bounds: bounds, in: geometry)
                }
            } else {
                background
                    .overlay(separator)
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

    @ViewBuilder var separator: some View {
        (message?.status?.color ?? .cloudNormal)
            .frame(width: borderWidth)
            .frame(maxHeight: .infinity)
            .padding(.vertical, BorderWidth.active)
    }

    private func selection(
        at location: CGPoint,
        preferences: [IDPreference],
        in geometry: GeometryProxy
    ) -> Selection? {
        let itemWidth = geometry.size.width / CGFloat(preferences.count)
        let index = Int((location.x / itemWidth).rounded(.down)).clamped(to: preferences.indices.dropLast())

        return selection(from: preferences[index])
    }

    private func isSelected(_ preference: IDPreference) -> Bool {
        selection == selection(from: preference)
    }

    private func selection(from preference: IDPreference) -> Selection? {
        preference.id.base as? Selection
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
}

private extension View {

    @ViewBuilder func segmentFrame(bounds: Anchor<CGRect>, in geometry: GeometryProxy) -> some View {
        let itemWidth = geometry.size.width / 2

        self
            .frame(width: itemWidth)
            .offset(x: (geometry[bounds].minX / itemWidth).rounded(.down) * itemWidth)
    }
}

public extension AccessibilityID {
    static let segmentedSwitchFirstOption = Self(rawValue: "orbit.segmentedswitch.first")
    static let segmentedSwitchSecondOption = Self(rawValue: "orbit.segmentedswitch.second")
}

// MARK: - Previews
struct SegmentedSwitchPreviews: PreviewProvider {

    enum Gender {
        case male
        case female
    }

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

private extension Comparable {

    func clamped(to range: Range<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

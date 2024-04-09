import SwiftUI

/// Orbit input component that displays a control for switching between multiple contents in a group.
/// A counterpart of the native `SwiftUI.Picker` with `segmented` style applied. A typical use case is switching between tabs in a native `SwiftUI.TabView`.
///
/// A ``Tabs`` consists of labels that represent specific tabs.
/// Each tab label must be given an Orbit  ``identifier(_:)`` that matches a value of the selection binding:
///
/// ```swift
/// Tabs(selection: $selectedTab) {
///     Text("One")
///         .identifier(1)
///     Text("Two")
///         .identifier(2)
///         .activeTabStyle(.underlinedGradient(.ink))
///     Text("Three")
///         .identifier(3)
///         .activeTabStyle(.underlined(.blueNormal))
/// }
/// 
/// TabView(selection: $selectedTab) {
///     tabContentNumberOne
///         .tag(1)
///     tabContentNumberTwo
///         .tag(2)
///     tabContentNumberThree
///         .tag(3)
/// }
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier.
/// 
/// ### Layout
/// 
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/structure/tabs/)
public struct Tabs<Selection: Hashable, Content: View>: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.idealSize) private var idealSize
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor
    @Binding private var selection: Selection
    @State private var activeTabStyles: [ActiveTabStyle] = []

    let backgroundColor: Color = .cloudLight
    let underlineHeight: CGFloat = .xxxSmall
    let content: Content

    let borderWidth: CGFloat = BorderWidth.active
    let horizontalPadding: CGFloat = .small

    public var body: some View {
        HStack(spacing: 0) {
            content
                .frame(maxWidth: isIdealSize ? nil : .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 6) // = 32 height @ normal size
                .multilineTextAlignment(.center)
                .textFontWeight(.medium)
                .environment(\.selectedTabIdentifier, AnyHashable(selection))
        }
        .onPreferenceChange(ActiveTabStyleKey.self) { value in
            activeTabStyles = value
        }
        .backgroundPreferenceValue(IDPreferenceKey.self) { preferences in
            tabsBackground(preferences)
        }
        .background(background)
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder func tabsBackground(_ preferences: [IDPreference]) -> some View {
        selectedTabButton(preferences)
            .background(separators(preferences))
            .background(unselectedTabButtons(preferences))
            .animation(.easeOut(duration: 0.2), value: selection)
    }

    @ViewBuilder func selectedTabButton(_ preferences: [IDPreference]) -> some View {
        tabButton(preferences: preferences, index: selectedIndex(from: preferences)) { geometry in
            VStack(spacing: 0) {
                (colorScheme == .light ? Color.whiteDarker : Color.cloudDarkActive)

                Rectangle()
                    .fill(activeTabStyle(preferences: preferences, geometry: geometry).underline)
                    .frame(height: underlineHeight * sizeCategory.ratio)
            }
            .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
            .elevation(.level1, shape: .roundedRectangle(borderRadius: BorderRadius.default - 1))
        }
    }

    @ViewBuilder func unselectedTabButtons(_ preferences: [IDPreference]) -> some View {
        ForEach(unselectedPreferences(preferences), id: \.1.id) { index, preference in
            tabButton(preferences: preferences, index: index) { _ in
                backgroundColor
                    .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
            }
        }
    }

    @ViewBuilder func tabButton(
        preferences: [IDPreference],
        index: Int,
        @ViewBuilder label: @escaping (GeometryProxy) -> some View
    ) -> some View {
        let preference = preferences[index]
        let isSelected = isSelected(preference)

        GeometryReader { geometry in
            let (width, minX) = measurements(
                index: index,
                preferences: preferences,
                isIdealSize: isIdealSize,
                horizontalPadding: horizontalPadding,
                in: geometry
            )

            SwiftUI.Button {
                if let newSelection = selection(from: preference) {
                    selection = newSelection
                }
            } label: {
                label(geometry)
                    .padding(.xxxSmall)
            }
            .buttonStyle(TransparentButtonStyle(isActive: isSelected, borderWidth: borderWidth, pressedOpacity: 0.7))
            .frame(width: width)
            .offset(x: minX)
            .accessibility(value: .init((selection(from: preference)).map(String.init(describing:)) ?? ""))
            .accessibility(addTraits: isSelected ? .isSelected : [])
        }
    }

    @ViewBuilder func separators(_ preferences: [IDPreference]) -> some View {
        let selectedIndex = selectedIndex(from: preferences)

        GeometryReader { geometry in
            ForEach(preferences.indices.dropLast(), id: \.self) { index in
                if index != selectedIndex, index != selectedIndex - 1 {
                    Color.cloudDark
                        .frame(width: .hairline)
                        .padding(.vertical, .xSmall)
                        .offset(x: separatorXOffset(index: index, preferences: preferences, geometry: geometry))
                }
            }
        }
    }

    @ViewBuilder var background: some View {
        RoundedRectangle(cornerRadius: BorderRadius.default)
            .fill(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .stroke(.cloudNormal, lineWidth: BorderWidth.thin)
            )
    }

    private func activeTabStyle(preferences: [IDPreference], geometry: GeometryProxy) -> TabStyle {
        guard let preference = preferences.first(where: isSelected) else { return .default }

        let activeBounds = geometry[preference.bounds]

        return activeTabStyles.first(where: { geometry[$0.bounds] == activeBounds })?.style ?? .default
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

    private func selectedIndex(from preferences: [IDPreference]) -> Int {
        preferences.firstIndex(where: isSelected) ?? 0
    }

    private func separatorXOffset(index: Int, preferences: [IDPreference], geometry: GeometryProxy) -> CGFloat {

        let (width, minX) = measurements(
            index: index,
            preferences: preferences,
            isIdealSize: isIdealSize,
            horizontalPadding: horizontalPadding,
            in: geometry
        )

        return minX + width
    }

    private var isIdealSize: Bool {
        idealSize.horizontal == true
    }

    /// Creates Orbit ``Tabs`` component.
    public init(selection: Binding<Selection>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
}

private func measurements(
    index: Int,
    preferences: [IDPreference],
    isIdealSize: Bool,
    horizontalPadding: CGFloat,
    in geometry: GeometryProxy
) -> (width: CGFloat, minX: CGFloat) {

    let width: CGFloat
    let minX: CGFloat

    if isIdealSize {
        width = geometry[preferences[index].bounds].width  + horizontalPadding * 2
        minX = preferences.prefix(index).reduce(into: 0) { finalMinX, preference in
            finalMinX += geometry[preference.bounds].width + horizontalPadding * 2
        }
    } else {
        width = geometry.size.width / CGFloat(preferences.count)
        minX = (geometry[preferences[index].bounds].minX / width).rounded(.down) * width
    }

    return (width, minX)
}

// MARK: - Types

struct ActiveTabStyleModifier: ViewModifier {

    @Environment(\.identifier) var parentIdentifier
    @Environment(\.selectedTabIdentifier) var selectedIdentifier
    @Environment(\.textColor) var textColor
    @State var preferenceIdentifier: AnyHashable?
    let style: TabStyle

    var isSelected: Bool {
        identifier == selectedIdentifier
    }

    var identifier: AnyHashable? {
        // we need to check both because we don't know in which order
        // the modifiers were applied to the content.
        //
        // If `.identifier` was applied first, we take it from preferences
        // If `activeTabStyle` was applied first, we take it from environment
        parentIdentifier ?? preferenceIdentifier
    }

    var finalTextColor: Color? {
        isSelected
            ? style.textColor ?? textColor
            : textColor ?? .inkDark
    }

    func body(content: Content) -> some View {
        content
            .anchorPreference(key: ActiveTabStyleKey.self, value: .bounds) { bounds in
                [ActiveTabStyle(style: style, bounds: bounds)]
            }
            .onPreferenceChange(IDPreferenceKey.self) { preference in
                preferenceIdentifier = preference.first?.id
            }
            .textColor(isSelected ? style.textColor : nil)
    }
}

private struct SelectedTabIdentifierKey: EnvironmentKey {
    static let defaultValue: AnyHashable? = nil
}

private extension EnvironmentValues {
    var selectedTabIdentifier: AnyHashable? {
        get { self[SelectedTabIdentifierKey.self] }
        set { self[SelectedTabIdentifierKey.self] = newValue }
    }
}

// MARK: - Previews
struct TabsPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneIntrinsic
            sizing
            intrinsicMultiline
            intrinsicSingleline
            equalMultiline
            equalSingleline
            forEach
            interactive
            snapshot
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(2) { index in
            Tabs(selection: index) {
                Text("One")
                    .identifier(1)
                Text("Two")
                    .identifier(2)
                Text("Three")
                    .identifier(3)
                Text("Four")
                    .identifier(4)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var standaloneIntrinsic: some View {
        StateWrapper(2) { index in
            Tabs(selection: index) {
                Text("One")
                    .identifier(1)
                Text("Two")
                    .identifier(2)
            }
            .idealSize()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            StateWrapper(2) { index in
                Tabs(selection: index) {
                    Text("One")
                        .identifier(1)
                    Text("Two")
                        .identifier(2)
                }
                .idealSize()
            }
            .measured()

            StateWrapper(2) { index in
                Tabs(selection: index) {
                    Text("One")
                        .identifier(1)
                        .idealSize()
                    Text("Two")
                        .identifier(2)
                        .idealSize()
                }

            }
            .measured()
            .padding()
        }
        .previewDisplayName()
    }

    static var intrinsicMultiline: some View {
        StateWrapper(2) { index in
            Tabs(selection: index) {
                Text("Light and much much much larger")
                    .identifier(1)
                    .activeTabStyle(.underlinedGradient(.bundleBasic))
                Text("Comfort")
                    .identifier(2)
                    .activeTabStyle(.underlinedGradient(.bundleMedium))
                Text("All")
                    .identifier(3)
                    .activeTabStyle(.underlinedGradient(.bundleTop))
            }
            .idealSize()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var intrinsicSingleline: some View {
        StateWrapper(2) { index in
            Tabs(selection: index) {
                Text("Light and much much much larger")
                    .identifier(1)
                    .activeTabStyle(.underlinedGradient(.bundleBasic))
                Text("Comfort")
                    .identifier(2)
                    .activeTabStyle(.underlined(.blueDark))
                Text("All")
                    .identifier(3)
            }
            .idealSize()
            .lineLimit(1)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var equalMultiline: some View {
        StateWrapper(2) { index in
            Tabs(selection: index) {
                Text("Light and much much much larger")
                    .identifier(1)
                    .activeTabStyle(.underlinedGradient(.bundleBasic))
                Text("Comfort")
                    .identifier(2)
                    .activeTabStyle(.underlinedGradient(.bundleMedium))
                Text("All")
                    .identifier(3)
                    .activeTabStyle(.underlinedGradient(.bundleTop))
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var equalSingleline: some View {
        StateWrapper(3) { index in
            Tabs(selection: index) {
                Text("Light and much much much larger")
                    .identifier(1)
                    .activeTabStyle(.underlinedGradient(.bundleBasic))
                Text("Comfort")
                    .identifier(2)
                    .activeTabStyle(.underlinedGradient(.bundleMedium))
                Text("All")
                    .identifier(3)
                    .activeTabStyle(.underlinedGradient(.bundleTop))
            }
            .lineLimit(1)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var forEach: some View {
        StateWrapper(2) { index in
            Tabs(selection: index) {
                ForEach(1..<8) { index in
                    Text("\(index)")
                        .identifier(index)
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var interactive: some View {
        StateWrapper(1) { index in
            VStack(spacing: .large) {
                Tabs(selection: index) {
                    Text("One")
                        .identifier(1)
                    Text("Two")
                        .identifier(2)
                    Text("Three")
                        .identifier(3)
                    Text("Four")
                        .identifier(4)
                }

                Button("Toggle") {
                    index.wrappedValue = index.wrappedValue == 4 ? 1 : index.wrappedValue + 1
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(spacing: -.medium) {
            standaloneIntrinsic
            standalone
            intrinsicMultiline
            intrinsicSingleline
            equalMultiline
            equalSingleline
        }
        .previewDisplayName()
    }
}

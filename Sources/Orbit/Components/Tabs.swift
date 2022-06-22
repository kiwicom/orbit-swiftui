import SwiftUI

public enum TabsDistribution {
    /// Distributes tab widths equally.
    case equal
    /// Distributes tab widths based on each tab intrinsic size.
    case intrinsic
}

/// Separates content into groups within a single context.
///
/// The following example shows component with 3 tabs:
///
///     var body: some View {
///         Tabs(selectedIndex: tabIndex) {
///             Tab("one")
///             Tab("two", style: .underlinedGradient(.ink))
///             Tab("three", style: .underlined(.blueNormal))
///         }
///     }
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/structure/tabs/)
public struct Tabs<Content: View>: View {

    @Environment(\.sizeCategory) var sizeCategory
    @Binding var selectedIndex: Int

    let underlineHeight: CGFloat = .xxxSmall
    let lineLimit: Int?
    let distribution: TabsDistribution
    @ViewBuilder let content: Content

    public var body: some View {
        HStack(spacing: 0) {
            content
                .lineLimit(lineLimit)
                .frame(maxWidth: maxTabWidth, minHeight: Layout.preferredSmallButtonHeight, maxHeight: .infinity)
        }
        .fixedSize(horizontal: false, vertical: true)
        .hidden()
        .backgroundPreferenceValue(Tab.PreferenceKey.self) { preferences in
            GeometryReader { geometry in
                tabs(for: preferences, in: geometry)
            }
        }
        .background(background)
    }

    @ViewBuilder var background: some View {
        RoundedRectangle(cornerRadius: BorderRadius.default)
            .fill(Color.cloudLight)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .stroke(Color.cloudNormal, lineWidth: BorderWidth.thin)
            )
    }

    @ViewBuilder func tabs(for preferences: Tab.PreferenceKey.Value, in geometry: GeometryProxy) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(preferences.indices, id: \.self) { index in
                tab(
                    index,
                    lastIndex: preferences.endIndex - 1,
                    preferences[index].label,
                    style: preferences[index].style
                )
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(activeTab(for: preferences, in: geometry), alignment: .leading)
        .animation(.easeOut(duration: 0.2), value: selectedIndex)
    }

    @ViewBuilder func tab(_ index: Int, lastIndex: Int, _ label: String, style: Tab.TabStyle) -> some View {
        Tab(label, style: style)
            .foregroundColor(index == selectedIndex ? style.textColor : .inkNormal)
            .lineLimit(lineLimit)
            .frame(maxWidth: maxTabWidth, minHeight: Layout.preferredSmallButtonHeight, maxHeight: .infinity)
            .overlay(separator(index: index, lastIndex: lastIndex), alignment: .trailing)
            .contentShape(Rectangle())
            .accessibility(addTraits: .isButton)
            .onTapGesture {
                selectedIndex = index
            }
    }

    @ViewBuilder func separator(index: Int, lastIndex: Int) -> some View {
        if (0 ..< lastIndex).contains(index), [selectedIndex, selectedIndex - 1].contains(index) == false {
            Color.cloudDarker
                .frame(width: .hairline)
                .padding(.vertical, .xSmall)
        }
    }

    @ViewBuilder func activeTab(for preferences: Tab.PreferenceKey.Value, in geometry: GeometryProxy) -> some View {
        activeTabBackground(style: preferences[selectedIndex].style)
            .frame(width: activeTabWidth(in: preferences, geometry: geometry))
            .offset(x: activeTabXOffset(in: preferences, geometry: geometry))
            .frame(maxHeight: .infinity)
    }

    @ViewBuilder func activeTabBackground(style: Tab.TabStyle) -> some View {
        VStack(spacing: 0) {
            Color.whiteNormal
            underline(style: style)
                .frame(height: underlineHeight * sizeCategory.ratio)
        }
        .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
        .elevation(.level1, prerender: false)
        .padding(.xxxSmall)
    }

    @ViewBuilder func underline(style: Tab.TabStyle) -> some View {
        LinearGradient(
            colors: [style.startColor, style.endColor],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }

    var maxTabWidth: CGFloat? {
        switch distribution {
            case .equal:        return .infinity
            case .intrinsic:    return nil
        }
    }

    func activeTabXOffset(in preferences: Tab.PreferenceKey.Value, geometry: GeometryProxy) -> CGFloat {
        switch distribution {
            case .equal:
                return CGFloat(selectedIndex) * geometry.size.width / CGFloat(preferences.count)
            case .intrinsic:
                let leadingPreferences = preferences.prefix(selectedIndex + 1)
                return leadingPreferences.dropLast().map { geometry[$0.bounds] }.map(\.width).reduce(0, +)
        }
    }

    func activeTabWidth(in preferences: Tab.PreferenceKey.Value, geometry: GeometryProxy) -> CGFloat {
        switch distribution {
            case .equal:
                return geometry.size.width / CGFloat(preferences.count)
            case .intrinsic:
                return geometry[preferences[selectedIndex].bounds].width
        }
    }
}

// MARK: - Inits
extension Tabs {

    /// Creates Orbit Tabs component, a wrapper for Tab subcomponents.
    public init(
        selectedIndex: Binding<Int>,
        distribution: TabsDistribution = .equal,
        lineLimit: Int? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._selectedIndex = selectedIndex
        self.distribution = distribution
        self.lineLimit = lineLimit
        self.content = content()
    }
}

// MARK: - Previews
struct TabsPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            product
            intrinsicMultiline
            intrinsicSingleline
            equalMultiline
            equalSingleline
            storybookLive
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index, distribution: .intrinsic) {
                Tab("One", style: .default)
                Tab("Two", style: .default)
            }
        }
        .padding(.medium)
    }

    static var storybook: some View {
        VStack(spacing: 0) {
            standalone
            product
            intrinsicMultiline
            intrinsicSingleline
            equalMultiline
            equalSingleline
        }
    }

    static var product: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index) {
                Tab("One", style: .product)
                Tab("Two", style: .product)
                Tab("Three", style: .product)
                Tab("Four", style: .product)
            }
        }
        .padding(.medium)
        .previewDisplayName("Product")
    }

    @ViewBuilder static var intrinsicMultiline: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index, distribution: .intrinsic) {
                Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
                Tab("Comfort", style: .underlinedGradient(.bundleMedium))
                Tab("All", style: .underlinedGradient(.bundleTop))
            }
        }
        .padding(.medium)
        .previewDisplayName("Intrinsic distribution, multiline")
    }

    @ViewBuilder static var intrinsicSingleline: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index, distribution: .intrinsic, lineLimit: 1) {
                Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
                Tab("Comfort", style: .underlined(.blueDark))
                Tab("All")
            }
        }
        .padding(.medium)
        .previewDisplayName("Intrinsic distribution, no multiline")
    }

    @ViewBuilder static var equalMultiline: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index) {
                Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
                Tab("Comfort", style: .underlinedGradient(.bundleMedium))
                Tab("All", style: .underlinedGradient(.bundleTop))
            }
        }
        .padding(.medium)
        .previewDisplayName("Equal distribution, multiline")
    }

    @ViewBuilder static var equalSingleline: some View {
        StateWrapper(initialState: 2) { index in
            Tabs(selectedIndex: index, lineLimit: 1) {
                Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
                Tab("Comfort", style: .underlinedGradient(.bundleMedium))
                Tab("All", style: .underlinedGradient(.bundleTop))
            }
        }
        .padding(.medium)
        .previewDisplayName("Equal distribution, no multiline")
    }

    static var storybookLive: some View {
        StateWrapper(initialState: 1) { index in
            VStack(spacing: .large) {
                Tabs(selectedIndex: index) {
                    Tab("One", style: .default)
                    Tab("Two", style: .default)
                    Tab("Three", style: .default)
                    Tab("Four", style: .default)
                }

                Button("Toggle") {
                    index.wrappedValue = index.wrappedValue == 1 ? 0 : 1
                }
            }
        }
        .padding(.medium)
        .previewDisplayName("Live Preview")
    }

    static var snapshot: some View {
        storybook
    }
}

struct TabsDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        TabsPreviews.storybook
        TabsPreviews.product
        TabsPreviews.equalMultiline
    }
}

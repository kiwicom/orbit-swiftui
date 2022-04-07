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

    @Binding var selectedIndex: Int

    let lineLimit: Int?
    let distribution: TabsDistribution
    let content: () -> Content

    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            content()
                .lineLimit(lineLimit)
                .frame(maxWidth: maxTabWidth, minHeight: Layout.preferredSmallButtonHeight, maxHeight: .infinity)
        }
        .fixedSize(horizontal: false, vertical: true)
        .opacity(0)
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
    }

    @ViewBuilder func tab(_ index: Int, lastIndex: Int, _ label: String, style: TabStyle) -> some View {
        Tab(label, style: style)
            .foregroundColor(index == selectedIndex ? style.textColor : .inkNormal)
            .lineLimit(lineLimit)
            .frame(maxWidth: maxTabWidth, minHeight: Layout.preferredSmallButtonHeight, maxHeight: .infinity)
            .overlay(separator(index: index, lastIndex: lastIndex), alignment: .trailing)
            .contentShape(Rectangle())
            .accessibility(addTraits: .isButton)
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.25)) {
                    selectedIndex = index
                }
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

    @ViewBuilder func activeTabBackground(style: TabStyle) -> some View {
        VStack(spacing: 0) {
            Color.white
            underline(style: style)
                .frame(height: .xxxSmall)
        }
        .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
        .shadow(color: .black.opacity(0.06), radius: 1, x: 0, y: 1)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 3)
        .padding(.xxxSmall)
    }

    @ViewBuilder func underline(style: TabStyle) -> some View {
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
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedIndex = selectedIndex
        self.distribution = distribution
        self.lineLimit = lineLimit
        self.content = content
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
        }
        .padding()
        .previewLayout(.sizeThatFits)

        livePreview
            .padding()
            .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Tabs(selectedIndex: .constant(1)) {
            Tab("One", style: .default)
            Tab("Two", style: .default)
            Tab("Three", style: .default)
            Tab("Four", style: .default)
        }
        .previewDisplayName("Default")
    }

    static var product: some View {
        Tabs(selectedIndex: .constant(0)) {
            Tab("One", style: .product)
            Tab("Two", style: .product)
            Tab("Three", style: .product)
            Tab("Four", style: .product)
        }
        .previewDisplayName("Product")
    }

    @ViewBuilder static var intrinsicMultiline: some View {
        Tabs(selectedIndex: .constant(1), distribution: .intrinsic) {
            Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
            Tab("Comfort", style: .underlinedGradient(.bundleMedium))
            Tab("All", style: .underlinedGradient(.bundleTop))
        }
        .previewDisplayName("Intrinsic distribution, multiline")
    }

    @ViewBuilder static var intrinsicSingleline: some View {
        Tabs(selectedIndex: .constant(1), distribution: .intrinsic, lineLimit: 1) {
            Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
            Tab("Comfort", style: .underlined(.blueDark))
            Tab("All")
        }
        .previewDisplayName("Intrinsic distribution, no multiline")
    }

    @ViewBuilder static var equalMultiline: some View {
        Tabs(selectedIndex: .constant(0)) {
            Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
            Tab("Comfort", style: .underlinedGradient(.bundleMedium))
            Tab("All", style: .underlinedGradient(.bundleTop))
        }
        .previewDisplayName("Equal distribution, multiline")
    }

    @ViewBuilder static var equalSingleline: some View {
        Tabs(selectedIndex: .constant(2), lineLimit: 1) {
            Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
            Tab("Comfort", style: .underlinedGradient(.bundleMedium))
            Tab("All", style: .underlinedGradient(.bundleTop))
        }
        .previewDisplayName("Equal distribution, no multiline")
    }

    static var livePreview: some View {
        PreviewWrapperWithState(initialState: 1) { state in
            Tabs(selectedIndex: state) {
                Tab("One", style: .default)
                Tab("Two", style: .default)
                Tab("Three", style: .default)
                Tab("Four", style: .default)
            }
        }
        .padding()
        .previewDisplayName("Live Preview")
    }
}

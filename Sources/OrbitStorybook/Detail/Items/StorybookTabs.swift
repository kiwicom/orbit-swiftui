import SwiftUI
import Orbit

struct StorybookTabs {

    static var basic: some View {
        VStack(spacing: .xLarge) {
            standaloneIntrinsic
            standalone
            intrinsicMultiline
            intrinsicSingleline
            equalMultiline
            equalSingleline
        }
    }

    static var live: some View {
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
        .previewDisplayName("Live Preview")
    }

    static var standaloneIntrinsic: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index, distribution: .intrinsic) {
                Tab("One", style: .default)
                Tab("Two", style: .default)
            }
        }
    }

    static var standalone: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index) {
                Tab("One")
                Tab("Two")
                Tab("Three")
                Tab("Four")
            }
        }
    }

    @ViewBuilder static var intrinsicMultiline: some View {
        StateWrapper(initialState: 1) { index in
            Tabs(selectedIndex: index, distribution: .intrinsic) {
                Tab("Light and much much much larger", style: .underlinedGradient(.bundleBasic))
                Tab("Comfort", style: .underlinedGradient(.bundleMedium))
                Tab("All", style: .underlinedGradient(.bundleTop))
            }
        }
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
        .previewDisplayName("Equal distribution, no multiline")
    }
}

struct StorybookTabsPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTabs.basic
            StorybookTabs.live
        }
    }
}

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
        .previewDisplayName()
    }

    static var live: some View {
        StateWrapper(2) { index in
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
    }

    @ViewBuilder static var intrinsicMultiline: some View {
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
        .previewDisplayName("Intrinsic distribution, multiline")
    }

    @ViewBuilder static var intrinsicSingleline: some View {
        StateWrapper(1) { index in
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
        .previewDisplayName("Intrinsic distribution, no multiline")
    }

    @ViewBuilder static var equalMultiline: some View {
        StateWrapper(1) { index in
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
        .previewDisplayName("Equal distribution, multiline")
    }

    @ViewBuilder static var equalSingleline: some View {
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
            .lineLimit(1)
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

import SwiftUI

/// An illustration matching Orbit name.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/illustration/)
/// - Important: The component expands horizontally to infinity in case of `.expanded` layout.
public struct Illustration: View {

    let name: String
    let bundle: Bundle
    let layout: Layout

    public var body: some View {
        if name.isEmpty == false {
            switch layout {
                case .frame(let minHeight, let maxHeight, let alignment):
                    resizeableImage
                        .frame(minHeight: minHeight, idealHeight: maxHeight, maxHeight: maxHeight)
                        .frame(maxWidth: .infinity, alignment: .init(alignment))
                case .resizeable:
                    resizeableImage
                case .intrinsic:
                    image
            }
        }
    }
    
    @ViewBuilder var resizeableImage: some View {
        image
            .resizable()
            .scaledToFit()
    }
    
    @ViewBuilder var image: SwiftUI.Image {
        SwiftUI.Image(name, bundle: bundle)
    }
}

// MARK: - Inits
public extension Illustration {

    /// Creates Orbit Illustration component using Orbit illustration asset.
    ///
    /// - Parameters:
    ///     - image: Orbit Illustration asset.
    ///     - size: Sizing behavior of image content.
    init(
        _ image: Image,
        layout: Layout = .frame()
    ) {
        self.name = image.assetName
        self.bundle = .current
        self.layout = layout
    }
    
    /// Creates Orbit Illustration component for custom image resource.
    ///
    /// - Parameters:
    ///     - name: Resource name. Empty value results in no illustration.
    ///     - bundle: The bundle to search for the image resource and localization.
    ///     - size: Sizing behavior of image content.
    init(
        _ name: String,
        bundle: Bundle,
        layout: Layout = .frame()
    ) {
        self.name = name
        self.bundle = bundle
        self.layout = layout
    }
}

// MARK: - Types
public extension Illustration {
    
    enum Layout {
        public static let defaultMinHeight: CGFloat = 10
        public static let defaultMaxHeight: CGFloat = 200
        
        /// Positions illustration, first scaled to fit height values, in a horizontally expanded frame with specified alignment.
        case frame(
            minHeight: CGFloat? = Self.defaultMinHeight,
            maxHeight: CGFloat? = Self.defaultMaxHeight,
            alignment: HorizontalAlignment = .center
        )
        /// Illustration with `resizable` and `scaledToFit` modifiers applied to allow further sizing.
        case resizeable
        /// Keeps original illustration size without applying any resize options.
        case intrinsic
    }
}

// MARK: - Previews
struct IllustrationPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            standalone
            intrinsic
            customResource

            stackFixed
            stackExpanding

            snapshot
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack {
            Illustration(.womanWithPhone)
            Illustration(.none) // EmptyView
        }
    }
    
    static var intrinsic: some View {
        Illustration(.womanWithPhone, layout: .intrinsic)
            .previewDisplayName("Intrinsic size")
    }

    static var customResource: some View {
        Illustration("WomanWithPhone", bundle: .current, layout: .intrinsic)
            .previewDisplayName("Custom image resource")
    }
    
    static var stackFixed: some View {
        VStack(spacing: .medium) {
            Illustration(.womanWithPhone)
                .border(Color.cloudDark)
            
            Illustration(.womanWithPhone)
                .border(Color.cloudDark)
        }
        .previewDisplayName("Fixed stack")
    }
    
    static var stackExpanding: some View {
        ScrollView {
            VStack(spacing: .medium) {
                Illustration(.womanWithPhone)
                    .border(Color.cloudDark)

                Illustration(.womanWithPhone)
                    .border(Color.cloudDark)
            }
        }
        .previewDisplayName("Expanding stack")
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("MaxHeight = 80") {
                VStack {
                    Text("Frame - Center (default)", size: .small)
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80))
                        .border(Color.cloudDark)
                }

                VStack {
                    Text("Frame - Leading", size: .small)
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80, alignment: .leading))
                        .border(Color.cloudDark)
                }

                VStack {
                    Text("Frame - Trailing", size: .small)
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80, alignment: .trailing))
                        .border(Color.cloudDark)
                }

                VStack {
                    Text("Resizeable", size: .small)
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(height: 80)
                        .border(Color.cloudDark)
                }
            }

            Card("MaxHeight = 30") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading", size: .small)
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30, alignment: .leading))
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Center", size: .small)
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30))
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Resizeable", size: .small)
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 30)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing", size: .small)
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30, alignment: .trailing))
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("Resizeable") {
                HStack(alignment: .top, spacing: .medium) {
                    VStack(alignment: .leading) {
                        Text("Width = 80", size: .small)
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(width: 80)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Height = 80", size: .small)
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 80)
                            .border(Color.cloudDark)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Width = 80, Height = 80", size: .small)
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(width: 80, height: 80)
                        .border(Color.cloudDark)
                }
            }
        }
        .padding(.vertical, .medium)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.cloudLight)
        .previewDisplayName("Mixed sizes")
    }

    static var storybook: some View {
        snapshot
    }
}

import SwiftUI

/// An illustration matching Orbit name.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/illustration/)
/// - Important: The component expands horizontally to infinity in case of `frame` layout, unless prevented by `idealSize` modifier.
public struct Illustration: View {

    @Environment(\.idealSize) var idealSize

    let name: String
    let bundle: Bundle
    let layout: Layout

    public var body: some View {
        if name.isEmpty == false {
            switch layout {
                case .frame(let maxHeight, let alignment):
                    resizeableImage
                        .frame(maxHeight: maxHeight)
                        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .init(alignment))
                        .fixedSize(horizontal: false, vertical: true)
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
    ///     - layout: Layout behavior of illustration content.
    ///     By default, a `frame` layout is used to automatically resize the illustration and center it horizontally.
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
    ///     - layout: Layout behavior of illustration content.
    ///     By default, a `frame` layout is used to automatically resize the illustration and center it horizontally.
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

    /// Illustration layout specifies how the illustration is resized and (optionally) horizontally aligned.
    enum Layout {

        /// Default maximal illustration height using frame layout.
        public static let maxHeight: CGFloat = 200

        /// Positions illustration, first scaled to fit the optional maxHeight, in a horizontally expanding frame with specified alignment.
        case frame(
            maxHeight: CGFloat = maxHeight,
            alignment: HorizontalAlignment = .center
        )
        /// Applies `resizable` and `scaledToFit` modifiers to allow free resizing.
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
            stackSmallerWidth
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
    
    static var stackSmallerWidth: some View {
        VStack(spacing: .medium) {
            Illustration(.womanWithPhone)
                .border(Color.cloudDark)
            
            Illustration(.womanWithPhone)
                .border(Color.cloudDark)
        }
        .frame(width: 150)
        .previewDisplayName("Smaller width")
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("Default", showBorder: false) {
                Illustration(.womanWithPhone)
                    .border(Color.cloudDark)
            }

            Card("MaxHeight = 80", showBorder: false) {
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

            Card("MaxHeight = 30", showBorder: false) {
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

            Card("Resizeable", showBorder: false) {
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
        .previewDisplayName("Mixed sizes")
    }

    static var storybook: some View {
        snapshot
    }
}

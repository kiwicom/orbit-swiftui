import SwiftUI
import Orbit

/// Orbit component that displays an illustration.
///
/// An ``Illustration`` is created using Orbit or custom resource.
///
/// ```swift
/// Illustration(.womanWithPhone)
/// Illustration("my-illustration", layout: .resizeable)
///     .frame(height: 50)
/// ```
///
/// ### Layout
/// 
/// The component expands horizontally to infinity in case of the default `frame` layout, unless prevented by `idealSize` modifier. A `resizeable` layout makes the illustration size to fit to desired size.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/illustration/)
public struct Illustration: View {

    @Environment(\.idealSize) var idealSize

    let name: String
    let bundle: Bundle
    let layout: Layout

    public var body: some View {
        if name.isEmpty == false {
            switch layout {
                case .frame(let height, let alignment):
                    resizeableImage
                        .frame(height: height)
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
    ///     - asset: Orbit Illustration asset.
    ///     - layout: Layout behavior of illustration content.
    ///     By default, a `frame` layout is used to automatically resize the illustration and center it horizontally.
    init(
        _ asset: Asset,
        layout: Layout = .frame()
    ) {
        self.name = asset.assetName
        self.bundle = .module
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

        /// Default illustration height when using frame layout.
        public static let height: CGFloat = 200

        /// Positions illustration, first scaled to fit the height, in a horizontally expanding frame with specified alignment.
        case frame(
            height: CGFloat = height,
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
        OrbitPreviewWrapper {
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
        .previewDisplayName()
    }
    
    static var intrinsic: some View {
        Illustration(.womanWithPhone, layout: .intrinsic)
            .previewDisplayName()
    }

    static var customResource: some View {
        Illustration("WomanWithPhone", bundle: .orbitIllustrations, layout: .intrinsic)
            .previewDisplayName()
    }
    
    static var stackSmallerWidth: some View {
        VStack(spacing: .medium) {
            Illustration(.womanWithPhone)
                .border(.cloudNormal)
            
            Illustration(.womanWithPhone)
                .border(.cloudNormal)
        }
        .frame(width: 150)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("Default", showBorder: false) {
                Illustration(.womanWithPhone)
                    .border(.cloudNormal)
            }

            Card("Height = 80", showBorder: false) {
                VStack {
                    Text("Frame - Center (default)")
                    Illustration(.womanWithPhone, layout: .frame(height: 80))
                        .border(.cloudNormal)
                }

                VStack {
                    Text("Frame - Leading")
                    Illustration(.womanWithPhone, layout: .frame(height: 80, alignment: .leading))
                        .border(.cloudNormal)
                }

                VStack {
                    Text("Frame - Trailing")
                    Illustration(.womanWithPhone, layout: .frame(height: 80, alignment: .trailing))
                        .border(.cloudNormal)
                }

                VStack {
                    Text("Resizeable")
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(height: 80)
                        .border(.cloudNormal)
                }
            }

            Card("Height = 30", showBorder: false) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading")
                        Illustration(.womanWithPhone, layout: .frame(height: 30, alignment: .leading))
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Center")
                        Illustration(.womanWithPhone, layout: .frame(height: 30))
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Resizeable")
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 30)
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing")
                        Illustration(.womanWithPhone, layout: .frame(height: 30, alignment: .trailing))
                            .border(.cloudNormal)
                    }
                }
            }

            Card("Resizeable", showBorder: false) {
                HStack(alignment: .top, spacing: .medium) {
                    VStack(alignment: .leading) {
                        Text("Width = 80")
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(width: 80)
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Height = 80")
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 80)
                            .border(.cloudNormal)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Width = 80, Height = 80")
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(width: 80, height: 80)
                        .border(.cloudNormal)
                }
            }
        }
        .textSize(.small)
        .previewDisplayName()
    }
}

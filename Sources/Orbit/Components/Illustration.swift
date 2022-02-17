import SwiftUI

/// An illustration matching Orbit name.
///
/// - Related components:
///   - ``Icon``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/illustration/)
/// - Important: The component expands horizontally to infinity if alignment is provided.
public struct Illustration: View {

    let name: String
    let bundle: Bundle
    let size: Size

    public var body: some View {
        if name.isEmpty == false {
            SwiftUI.Image(name, bundle: bundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                .frame(maxWidth: wrapperMaxWidth, alignment: wrapperAlignment)
        }
    }

    var wrapperMaxWidth: CGFloat? {
        switch size {
            case .expanding:                    return .infinity
            case .intrinsic:                    return nil
        }
    }
    
    var wrapperAlignment: Alignment {
        switch size {
            case .expanding(_, .leading):       return .leading
            case .expanding(_, .center):        return .center
            case .expanding(_, .trailing):      return .trailing
            default:                            return .center
        }
    }
    
    var maxWidth: CGFloat? {
        switch size {
            case .expanding:                    return nil
            case .intrinsic(let maxWidth, _):   return maxWidth
        }
    }
    
    var maxHeight: CGFloat? {
        switch size {
            case .expanding(let maxHeight, _), .intrinsic(_, let maxHeight):   return maxHeight
        }
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
        size: Size = .expanding()
    ) {
        self.name = image.assetName
        self.bundle = .current
        self.size = size
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
        size: Size = .expanding()
    ) {
        self.name = name
        self.bundle = bundle
        self.size = size
    }
}

// MARK: - Types
public extension Illustration {
    
    enum Size {
        public static let defaultMaxHeight: CGFloat = 200
        
        /// Scales illustration up to optional maxHeight and expand horizontally to infinity with specified alignment.
        case expanding(maxHeight: CGFloat? = Self.defaultMaxHeight, alignment: HorizontalAlignment = .center)
        /// Scales illustraton up to maxWidth and/or maxHeight.
        case intrinsic(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil)
    }
}

// MARK: - Previews
struct IllustrationPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            standalone
            intrinsic
            custom

            snapshots

            ScrollView {
                orbit
            }
            .previewDisplayName("All illustrations")
        }
    }
    
    static var standalone: some View {
        Illustration(.womanWithPhone)
            .previewLayout(.sizeThatFits)
    }
    
    static var intrinsic: some View {
        HStack {
            Illustration(.womanWithPhone, size: .intrinsic(maxHeight: 80))
                .border(.blue)
            Illustration(.time, size: .intrinsic(maxHeight: 40))
                .border(.blue)
        }
        .previewLayout(.sizeThatFits)
    }
    
    
    static var custom: some View {
        Illustration("WomanWithPhone", bundle: .current)
            .previewLayout(.sizeThatFits)
    }

    static var snapshots: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("Default size") {
                HStack {
                    VStack {
                        Text("Center (default)", size: .small)
                        Illustration(.womanWithPhone)
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("Default size") {
                HStack {
                    VStack {
                        Text("Leading", size: .small)
                        Illustration(.womanWithPhone, size: .expanding(alignment: .leading))
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("Default size") {
                HStack {
                    VStack {
                        Text("Intrinsic", size: .small)
                        Illustration(.womanWithPhone, size: .intrinsic())
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("MaxWidth = 40") {
                HStack {
                    Illustration(.womanWithPhone, size: .intrinsic(maxWidth: 40))
                        .border(Color.cloudDark)
                }
            }

            Card("MaxHeight = 30") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading", size: .small)
                        Illustration(.womanWithPhone, size: .expanding(maxHeight: 30, alignment: .leading))
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Center", size: .small)
                        Illustration(.womanWithPhone, size: .expanding(maxHeight: 30))
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("None", size: .small)
                        Illustration(.womanWithPhone, size: .intrinsic(maxHeight: 30))
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing", size: .small)
                        Illustration(.womanWithPhone, size: .expanding(maxHeight: 30, alignment: .trailing))
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("MaxWidth = 40, MaxHeight = 30") {
                Illustration(.womanWithPhone, size: .intrinsic(maxWidth: 40, maxHeight: 30))
                    .border(Color.cloudDark)
            }
        }
        .padding(.vertical)
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Snapshots")
    }

    static var orbit: some View {
        VStack(spacing: .small) {
            ForEach(Illustration.Image.allCases, id: \.self) { image in
                Separator(image.assetName)
                Illustration(image, size: .expanding(maxHeight: 60))
            }
        }
        .padding(.horizontal)
    }
}

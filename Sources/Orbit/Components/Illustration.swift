import SwiftUI

/// An illustration matching Orbit name.
///
/// - Related components:
///   - ``Icon``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/illustration/)
/// - Important: The component expands horizontally to infinity if alignment is provided.
public struct Illustration: View {

    public static let defaultWidth: CGFloat = 300

    let image: Image
    let maxWidth: CGFloat?
    let maxHeight: CGFloat?
    let alignment: Alignment?

    public var body: some View {
        SwiftUI.Image(image.assetName, bundle: .current)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .frame(maxWidth: wrapperMaxWidth, alignment: alignment ?? .center)
            .fixedSize(horizontal: false, vertical: true)
    }

    var wrapperMaxWidth: CGFloat? {
        alignment == nil ? nil : .infinity
    }
}

// MARK: - Inits
public extension Illustration {

    /// Creates Orbit Illustration component for provided image.
    ///
    /// - Parameters:
    ///     - image: Orbit Image
    ///     - maxWidth: Maximum width of the resizeable image content. Detaults to ``Illustration/defaultWidth``.
    ///     - maxHeight: Maximum height of the resizeable image content. Defaults to `nil`.
    ///     - alignment: If provided, expands horizontally to infinity and aligns the resulting resized image.
    ///     Defaults to `.center`.
    init(
        _ image: Image,
        maxWidth: CGFloat? = Self.defaultWidth,
        maxHeight: CGFloat? = nil,
        alignment: Alignment? = .center
    ) {
        self.image = image
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.alignment = alignment
    }
}

// MARK: - Previews
struct IllustrationPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            standalone

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
                        Illustration(.womanWithPhone, alignment: .leading)
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("Default size") {
                HStack {
                    VStack {
                        Text("No alignment", size: .small)
                        Illustration(.womanWithPhone, alignment: nil)
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("MaxWidth = 40") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40, alignment: .leading)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Center", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("None", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40, alignment: nil)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40, alignment: .trailing)
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("MaxHeight = 30") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading", size: .small)
                        Illustration(.womanWithPhone, maxWidth: nil, maxHeight: 30, alignment: .leading)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Center", size: .small)
                        Illustration(.womanWithPhone, maxWidth: nil, maxHeight: 30)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("None", size: .small)
                        Illustration(.womanWithPhone, maxWidth: nil, maxHeight: 30, alignment: nil)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing", size: .small)
                        Illustration(.womanWithPhone, maxWidth: nil, maxHeight: 30, alignment: .trailing)
                            .border(Color.cloudDark)
                    }
                }
            }

            Card("MaxWidth = 40, MaxHeight = 30") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40, maxHeight: 30, alignment: .leading)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Center", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40, maxHeight: 30)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("None", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40, maxHeight: 30, alignment: nil)
                            .border(Color.cloudDark)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing", size: .small)
                        Illustration(.womanWithPhone, maxWidth: 40, maxHeight: 30, alignment: .trailing)
                            .border(Color.cloudDark)
                    }
                }
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
                Illustration(image, maxHeight: 100, alignment: .center)
            }
        }
        .padding(.horizontal)
    }
}

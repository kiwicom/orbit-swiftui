import SwiftUI

/// Orbit component that displays one or more logos of transport carriers.
///
/// Carrier logos can include up to four logos at once. With one logo, by default it occupies the entire space.
/// With multiple logos, the logos are shrunk to the same size (no matter how many more there are).
///
/// To create visual balance, the logos are positioned differently depending on their number. With two logos,
/// they’re in the top left and bottom right. With three, the second logo shifts to the bottom left
/// and the third is present in the top right. With four, the logos take up all four corners.
///
/// ### Layout
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/visuals/carrierlogo/)
public struct CarrierLogo: View, PotentiallyEmptyView {
    
    private let images: [Image]
    private let size: Icon.Size
    
    public var body: some View {
        content
            .frame(width: size.value, height: size.value)
    }
    
    @ViewBuilder private var content: some View {
        switch images.count {
            case 0:  EmptyView()
            case 1:  SingleCarrierImage(image: images[0])
            case 2:  twoImages
            case 3:  threeImages
            default: fourImages
        }
    }
    
    @ViewBuilder private var twoImages: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SingleCarrierImage(image: images[0])
                Color.clear
            }
            HStack(spacing: 0) {
                Color.clear
                SingleCarrierImage(image: images[1])
            }
        }
    }
    
    @ViewBuilder private var threeImages: some View {
        VStack(spacing: .xxxSmall) {
            HStack(spacing: .xxxSmall) {
                SingleCarrierImage(image: images[0])
                SingleCarrierImage(image: images[2])
            }
            HStack(spacing: .xxxSmall) {
                SingleCarrierImage(image: images[1])
                Color.clear
            }
        }
    }
    
    @ViewBuilder private var fourImages: some View {
        VStack(spacing: .xxxSmall) {
            HStack(spacing: .xxxSmall) {
                SingleCarrierImage(image: images[0])
                SingleCarrierImage(image: images[2])
            }
            HStack(spacing: .xxxSmall) {
                SingleCarrierImage(image: images[1])
                SingleCarrierImage(image: images[3])
            }
        }
    }
    
    var isEmpty: Bool {
        images.isEmpty
    }
}

// MARK: - Inits
public extension CarrierLogo {
        
    /// Creates an Orbit ``CarrierLogo`` component with a single logo image.
    /// 
    /// - Parameters:
    ///   - image: a logo image.
    ///   - size: the size of the view. The image will occupy the whole view.
    init(image: Image, size: Icon.Size) {
        self.images = [image]
        self.size = size
    }
        
    /// Creates an Orbit ``CarrierLogo`` component with multiple images.
    /// 
    /// - Parameter images: logo images to show in the view.
    init(images: [Image]) {
        self.images = images
        self.size = .large
    }
}

// MARK: - Types
private extension CarrierLogo {
    
    struct SingleCarrierImage: View {
        
        let image: Image
        
        var body: some View {
            image
                .resizable()
                .cornerRadius(BorderRadius.desktop)
        }
    }
}

// MARK: - Previews
struct CarrierLogoPreviews: PreviewProvider {
    
    static let square = Image(systemName: "square.fill")
    static let plane1 = Image(systemName: "airplane.circle.fill")
    static let plane2 = Image(systemName: "paperplane.circle.fill")
    static let plane3 = Image(systemName: "airplane")
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            sizes
            sizesLogo
            twoLogos
            threeLogos
            fourLogos
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            CarrierLogo(images: [square, plane1, plane2, plane3])
            CarrierLogo(images: []) // EmptyView
        }
        .previewDisplayName()
    }

    @ViewBuilder static var sizes: some View {
        HStack(alignment: .top, spacing: .medium) {
            CarrierLogo(image: square, size: .small)
            CarrierLogo(image: square, size: .normal)
            CarrierLogo(image: square, size: .large)
        }
        .previewDisplayName()
    }

    @ViewBuilder static var sizesLogo: some View {
        HStack(alignment: .top, spacing: .medium) {
            CarrierLogo(image: plane1, size: .small)
            CarrierLogo(image: plane1, size: .normal)
            CarrierLogo(image: plane1, size: .large)
        }
        .previewDisplayName()
    }

    @ViewBuilder static var twoLogos: some View {
        CarrierLogo(images: [square, square])
            .previewDisplayName()
    }

    @ViewBuilder static var threeLogos: some View {
        CarrierLogo(images: [square, square, square])
            .previewDisplayName()
    }

    @ViewBuilder static var fourLogos: some View {
        CarrierLogo(images: [square, square, square, square])
            .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
            .padding(.medium)
    }
}

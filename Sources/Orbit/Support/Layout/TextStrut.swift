import SwiftUI

/// Invisible vertical line of fixed height based on text size.
///
/// Can be used to unify the height of elements that contain variable combination of icons and texts.
public struct TextStrut: View {

    @Environment(\.sizeCategory) var sizeCategory

    let textSize: Text.Size

    public var body: some View {
        Strut(height)
    }

    var height: CGFloat {
        // This approximation should match ascent+descent font property for all size variants
        textSize.height * (0.25 + 0.75 * sizeCategory.ratio)
    }

    /// Creates invisible strut of height of text based on provided text size.
    public init(_ textSize: Text.Size) {
        self.textSize = textSize
    }
}

// MARK: - Previews
struct TextStrutPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            iconAndText
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TextStrut(.normal)
            .padding(.horizontal, 1)
            .overlay(Color.redNormal)
            .padding(.medium)
            .previewDisplayName()
    }

    static var iconAndText: some View {
        VStack {
            stack(.small)
            stack(.normal)
            stack(.xLarge)
            stack(.custom(40))
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func stack(_ size: Text.Size) -> some View {
        HStack(spacing: .xxxSmall) {
            Icon(.grid, size: .text(size))
                .background(Color.redLightActive)
            TextStrut(size)
                .padding(.horizontal, 1)
                .overlay(Color.redNormal)
            Text("Text", size: size)
                .background(Color.redLightActive)
        }
    }
}

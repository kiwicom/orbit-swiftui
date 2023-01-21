import SwiftUI

/// Invisible vertical line of fixed height based on text line height.
///
/// Can be used to force minimal height of elements that contain variable combination of icons and texts.
public struct TextStrut: View {

    @Environment(\.sizeCategory) var sizeCategory

    let textSize: Text.Size
    
    public var body: some View {
        Color.clear
            .frame(width: 0, height: textSize.lineHeight * sizeCategory.ratio)
    }

    /// Creates invisible strut with height based on provided text size.
    public init(_ textSize: Text.Size = .normal) {
        self.textSize = textSize
    }
}

// MARK: - Previews
struct TextStrutPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            select
            tile
        }
        .previewLayout(.sizeThatFits)
    }

    static var select: some View {
        Select("", value: "Select", action: {})
            .overlay(
                strut(padding: .small)
            )
            .measured()
        .padding(.medium)
        .previewDisplayName()
    }

    static var tile: some View {
        Tile(action: {})
            .overlay(
                strut(.large, padding: 14)
            )
            .measured()
        .padding(.medium)
        .previewDisplayName()
    }

    static func strut(_ size: Text.Size = .normal, padding: CGFloat) -> some View {
        TextStrut(size)
            .frame(width: .xxxSmall)
            .overlay(Color.greenNormal)
            .padding(.vertical, padding)
            .background(Color.redNormal)
    }
}

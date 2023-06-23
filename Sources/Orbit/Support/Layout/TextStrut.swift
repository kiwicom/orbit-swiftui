import SwiftUI

/// Invisible vertical line of fixed height based on text line height.
///
/// Can be used to force minimal height of elements that contain variable combination of icons and texts.
public struct TextStrut: View {

    @Environment(\.textSize) private var textSize
    @Environment(\.textLineHeight) private var textLineHeight
    @Environment(\.sizeCategory) private var sizeCategory
    
    public var body: some View {
        Color.clear
            .frame(width: 0, height: lineHeight * sizeCategory.ratio)
            .alignmentGuide(.firstTextBaseline) { _ in size }
            .alignmentGuide(.lastTextBaseline) { _ in size }
    }

    private var lineHeight: CGFloat {
        textLineHeight ?? Text.Size.lineHeight(forTextSize: size)
    }

    private var size: CGFloat {
        textSize ?? Text.Size.normal.value
    }

    /// Creates invisible strut with height based on provided text size.
    ///
    /// Provide the text size and optional line height using `textSize()` and `textLineHeight()` modifiers.
    public init() {}
}

// MARK: - Previews
struct TextStrutPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            select
            alignment
            tile
        }
        .previewLayout(.sizeThatFits)
    }

    static var select: some View {
        Select("", value: "Select", action: {})
            .overlay(
                strut(padding: .small)
                    .textSize(.small)
            )
            .measured()
        .padding(.medium)
        .previewDisplayName()
    }

    static var alignment: some View {
        VStack(alignment: .leading, spacing: .medium) {
            HStack(alignment: .firstTextBaseline) {
                Text("Text")
                TextStrut()
                    .frame(width: .xxxSmall)
                    .overlay(Color.greenNormal)
            }
            .background(Color.redLight)

            HStack(alignment: .firstTextBaseline) {
                Text("Text")
                TextStrut()
                    .frame(width: .xxxSmall)
                    .overlay(Color.greenNormal)
            }
            .textSize(.xLarge)
            .background(Color.redLight)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var tile: some View {
        Tile(action: {})
            .overlay(
                strut(padding: 14)
                    .textSize(.large)
            )
            .measured()
        .padding(.medium)
        .previewDisplayName()
    }

    static func strut(padding: CGFloat) -> some View {
        TextStrut()
            .frame(width: .xxxSmall)
            .overlay(Color.greenNormal)
            .padding(.vertical, padding)
            .background(Color.redNormal)
    }
}

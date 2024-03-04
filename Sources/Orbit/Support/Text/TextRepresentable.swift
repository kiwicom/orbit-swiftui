import SwiftUI

/// A type that can be represented as `SwiftUI.Text` and can serve as Orbit concatenable component.
///
/// Use the `+` operator to concatenate ``TextRepresentable`` elements.
public protocol TextRepresentable {

    /// Extracts native `SwiftUI.Text` from type that represents textual content.
    func swiftUIText(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text?
}

/// Environment values required for proper formatting of concatenated Orbit text components.
public struct TextRepresentableEnvironment {

    public let iconColor: Color?
    public let iconSize: CGFloat?
    public let locale: Locale
    public let textAccentColor: Color?
    public let textColor: Color?
    public let textFontWeight: Font.Weight?
    public let textLineHeight: CGFloat?
    public let textSize: CGFloat?
    public let sizeCategory: ContentSizeCategory

    public init(
        iconColor: Color?,
        iconSize: CGFloat?,
        locale: Locale,
        textAccentColor: Color?,
        textColor: Color?,
        textFontWeight: Font.Weight?,
        textLineHeight: CGFloat?,
        textSize: CGFloat?,
        sizeCategory: ContentSizeCategory
    ) {
        self.iconColor = iconColor
        self.iconSize = iconSize
        self.locale = locale
        self.textAccentColor = textAccentColor
        self.textColor = textColor
        self.textFontWeight = textFontWeight
        self.textLineHeight = textLineHeight
        self.textSize = textSize
        self.sizeCategory = sizeCategory
    }

    func designatedLineHeight(_ lineHeight: CGFloat?, size: CGFloat?) -> CGFloat {
        (lineHeight ?? textLineHeight ?? (Text.Size.lineHeight(forTextSize: resolvedSize(size))))
            * sizeCategory.ratio
    }

    func lineHeightPadding(lineHeight: CGFloat?, size: CGFloat?) -> CGFloat {
        (designatedLineHeight(lineHeight, size: size) - originalLineHeight(size: size)) / 2
    }

    func lineSpacingAdjusted(_ lineSpacing: CGFloat, lineHeight: CGFloat?, size: CGFloat?) -> CGFloat {
        designatedLineHeight(lineHeight, size: size)
            - originalLineHeight(size: size)
            + lineSpacing
    }

    func originalLineHeight(size: CGFloat?) -> CGFloat {
        UIFont.lineHeight(size: scaledSize(size))
    }

    func scaledSize(_ size: CGFloat?) -> CGFloat {
        resolvedSize(size) * sizeCategory.ratio
    }

    func resolvedAccentColor(_ accentColor: Color?, color: Color?) -> Color {
        accentColor
            ?? textAccentColor
            ?? resolvedColor(color)
    }

    func resolvedFontWeight(_ weight: Font.Weight?, isBold: Bool?) -> Font.Weight? {
        isBold == true
            ? .bold
            : weight ?? textFontWeight
    }

    func resolvedSize(_ size: CGFloat?) -> CGFloat {
        (size ?? textSize ?? Text.Size.normal.value)
    }

    func resolvedColor(_ color: Color?) -> Color {
        color ?? textColor ?? .inkDark
    }

    func font(size: CGFloat?, weight: Font.Weight?, isBold: Bool?) -> Font {
        .orbit(
            size: resolvedSize(size) * sizeCategory.ratio,
            weight: resolvedFontWeight(weight, isBold: isBold) ?? .regular
        )
    }
}

/// Concatenates two terms that can be represented as `SwiftUI.Text`.
///
/// - Parameters:
///   - left: A content representable as `SwiftUI.Text`.
///   - right: A content representable as `SwiftUI.Text`.
/// - Returns: A view that is the result of concatenation of text representation of the parameters. If neither parameter has a text representation, EmptyView will be returned.
@ViewBuilder public func +(
    left: TextRepresentable,
    right: TextRepresentable
) -> some View & TextRepresentable {
    ConcatenatedText(left) + ConcatenatedText(right)
}

// MARK: - Previews
struct TextConcatenationPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            formatting
            sizing
            snapshot
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        (
            Heading("Hanoi ", style: .title1)
            + Icon(.grid)
                .iconSize(.xLarge)
            + Icon(.grid)
                .iconSize(.small)
                .iconColor(.redNormal)
            + Icon(.grid)
                .iconSize(.small)
                .iconColor(.blueDark)
            + Heading(" San Pedro de Alcantara", style: .title1)
                .textColor(.blueNormal)
                .fontWeight(.black)
                .strikethrough()
            + Text(" ")
            + Icon("info.circle")
                .iconSize(.large)
                .iconColor(.blueDark)
            + Text(" (Delayed)")
                .textSize(.xLarge)
                .textColor(.inkNormal)
        )
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .trailing, spacing: .xxSmall) {
            Group {
                Text("Normal Text")

                Text("Concatenated ")
                    .textColor(.blueDark)
                + Text("Text")

                Text("Normal\nText")

                Text("Concatenated\n")
                    .textColor(.blueDark)
                + Text("Text")

                Group {
                    Text("Normal\nText")

                    Text("Concatenated\n")
                        .textColor(.blueDark)
                    + Text("Text")
                }
                .lineSpacing(6)

                Text("Normal Text")

                Text("Concatenated ")
                    .textColor(.blueDark)
                    .textSize(custom: 8)
                + Text("Text")
                    .textSize(.normal)
            }
            .background(Color.redLight)
            .measured()
        }
        .multilineTextAlignment(.trailing)
        .previewDisplayName()
    }

    static var formatting: some View {
        (
            Icon(.grid)
                .iconSize(.xLarge)
            + Text(" Text ")
                .textSize(.xLarge)
                .bold()
                .italic()
            + Icon(.informationCircle)
                .iconSize(.large)
                .baselineOffset(-1)
            + Icon("info.circle.fill")
                .iconSize(.large)
            + Text(" <ref>Text</ref> with <strong>formatting</strong>")
                .textSize(.small)
            + Icon(.check)
                .iconSize(.small)
                .iconColor(.greenDark)
        )
        .textColor(.blueDark)
        .textAccentColor(.orangeNormal)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            concatenatedText("Title 1", style: .title1)
            concatenatedText("Title 2", style: .title2)
            concatenatedText("Title 3", style: .title3)
            concatenatedText("Title 4", style: .title4)
            concatenatedText("Title 5", style: .title5)
            concatenatedText("Title 6", style: .title6)
        }
        .previewDisplayName()
    }

    static func concatenatedText(_ label: String, style: Heading.Style) -> some View {
        HStack {
            Heading(label, style: style)
                .textColor(.inkDark)
                + Icon(.flightReturn)
                    .iconSize(custom: style.size)
                    .iconColor(.inkNormal)
                + Heading(label, style: style)
                    .textColor(.inkDark)
                + Text(" and Text")
        }
        .textColor(.blueDark)
        .previewDisplayName()
    }
}

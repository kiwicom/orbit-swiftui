import SwiftUI
import Orbit

struct StorybookIcon {

    static let multilineText = "Multiline\nlong\ntext"
    static let sfSymbol = "info.circle.fill"

    static var basic: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            sizes
            matchingText
            matchingHeading
        }
        .previewDisplayName()
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            size(iconSize: .small, textSize: .small, color: .redNormal)
            size(iconSize: .normal, textSize: .normal, color: .orangeNormal)
            size(iconSize: .large, textSize: .large, color: .greenNormal)
            size(iconSize: .xLarge, textSize: .xLarge, color: .blueNormal)
        }
    }

    static var matchingText: some View {
        VStack(alignment: .leading, spacing: .small) {
            textStack(.small, alignment: .firstTextBaseline)
            textStack(.normal, alignment: .firstTextBaseline)
            textStack(.large, alignment: .firstTextBaseline)
        }
    }

    static var matchingHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            headingStack(.title6, alignment: .firstTextBaseline)
            headingStack(.title5, alignment: .firstTextBaseline)
            headingStack(.title4, alignment: .firstTextBaseline)
            headingStack(.title3, alignment: .firstTextBaseline)
            headingStack(.title2, alignment: .firstTextBaseline)
            headingStack(.title1, alignment: .firstTextBaseline)
        }
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Heading("Standalone", style: .title6)

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Text("Text")
                    Icon(sfSymbol)
                    Icon(sfSymbol)
                        .baselineOffset(.xxxSmall)

                    Icon(.informationCircle)
                    Icon(.informationCircle)
                        .baselineOffset(.xxxSmall)
                }
                .border(.cloudLightActive, width: .hairline)
            }
            .textSize(.small)
            .iconSize(.small)
            .textColor(.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )

            Heading("Concatenated text", style: .title6)
                .padding(.top, .xLarge)

            (
                Text("Text")
                + Icon(sfSymbol)
                + Icon(sfSymbol)
                    .baselineOffset(.xxxSmall)

                + Icon(.informationCircle)
                + Icon(.informationCircle)
                    .baselineOffset(.xxxSmall)
            )
            .textSize(.small)
            .iconSize(.small)
            .textColor(.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )

            Heading("Color override", style: .title6)
                .padding(.top, .xLarge)

            VStack(alignment: .leading, spacing: .small) {
                HStack(alignment: .firstTextBaseline) {
                    Icon(.grid)
                    Icon(.grid)
                        .textColor(.blueNormal)
                }

                HStack(alignment: .firstTextBaseline) {
                    Icon(sfSymbol)
                    Icon(sfSymbol)
                        .textColor(.blueNormal)
                }
            }
            .textColor(.greenNormalHover)
        }
        .previewDisplayName()
    }

    static func size(iconSize: Icon.Size, textSize: Orbit.Text.Size, color: Color) -> some View {
        HStack(spacing: .xSmall) {
            Text("\(Int(iconSize.value))")
                .textColor(color)
                .bold()

            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers)
                    .iconSize(iconSize)
                Text("\(String(describing: textSize).titleCased) text and icon size")
                    .textSize(textSize)
            }
            .overlay(Separator(thickness: .hairline), alignment: .top)
            .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }

    static func headingStack(_ style: Heading.Style, alignment: VerticalAlignment) -> some View {
        alignmentStack(style.lineHeight, alignment: alignment) {
            Heading("\(style)".capitalized, style: style)
        }
    }

    static func textStack(_ size: Orbit.Text.Size, alignment: VerticalAlignment) -> some View {
        alignmentStack(Icon.Size.fromTextSize(size: size.value), alignment: alignment) {
            Text("Text \(Int(size.value))")
                .textSize(size)
        }
    }

    static func alignmentStack<V: View>(_ size: CGFloat, alignment: VerticalAlignment, @ViewBuilder content: () -> V) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: alignment, spacing: .xxSmall) {
                Group {
                    Icon(sfSymbol)
                    Icon(.informationCircle)
                    content()
                }
                .iconSize(custom: size)
                .background(Color.redLightHover)
            }
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .init(horizontal: .center, vertical: alignment)
            )
            .background(
                Separator(color: .greenNormal, thickness: .hairline),
                alignment: .init(horizontal: .center, vertical: .top)
            )
            .background(
                Separator(color: .greenNormal, thickness: .hairline),
                alignment: .init(horizontal: .center, vertical: .bottom)
            )
        }
    }
}

struct StorybookIconPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookIcon.basic
            StorybookIcon.mix
        }
    }
}

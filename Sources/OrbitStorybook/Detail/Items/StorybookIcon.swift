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
            textStack(.custom(30), alignment: .firstTextBaseline)
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
                    Text("Text", size: .small)
                    Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                    Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                        .baselineOffset(.xxxSmall)

                    Icon(.informationCircle, size: .small, color: nil)
                    Icon(.informationCircle, size: .small, color: nil)
                        .baselineOffset(.xxxSmall)

                    Group {
                        Icon(image: .orbit(.navigateClose), size: .small, tint: nil)
                        Icon(image: .orbit(.navigateClose), size: .small, tint: nil)
                            .baselineOffset(.xxxSmall)
                        Icon(image: .orbit(.facebook), size: .small)
                        Icon(image: .orbit(.facebook), size: .small)
                            .baselineOffset(.xxxSmall)
                    }

                    Icon(countryCode: "us", size: .small)
                    Icon(countryCode: "us", size: .small)
                        .baselineOffset(.xxxSmall)
                }
                .border(.cloudLightActive, width: .hairline)
            }
            .foregroundColor(.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )

            Heading("Concatenated text", style: .title6)
                .padding(.top, .xLarge)

            (
                Text("Text", size: .small)
                + Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                + Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                    .baselineOffset(.xxxSmall)

                + Icon(.informationCircle, size: .small, color: nil)
                + Icon(.informationCircle, size: .small, color: nil)
                    .baselineOffset(.xxxSmall)

                + Icon(image: .orbit(.navigateClose), tint: nil)
                + Icon(image: .orbit(.navigateClose), tint: nil)
                    .baselineOffset(.xxxSmall)
                + Icon(image: .orbit(.facebook))
                + Icon(image: .orbit(.facebook))
                    .baselineOffset(.xxxSmall)
            )
            .foregroundColor(.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )

            Heading("Color override", style: .title6)
                .padding(.top, .xLarge)

            VStack(alignment: .leading, spacing: .small) {
                HStack(alignment: .firstTextBaseline) {
                    Icon(.grid)
                    Icon(.grid, color: .blueNormal)
                    Icon(.grid, color: nil)
                    Icon(.grid)
                    Icon(.symbol(.grid, color: nil))
                }

                HStack(alignment: .firstTextBaseline) {
                    Icon(sfSymbol: sfSymbol)
                    Icon(sfSymbol: sfSymbol, color: .blueNormal)
                    Icon(sfSymbol: sfSymbol, color: nil)
                    Icon(.sfSymbol(sfSymbol))
                    Icon(.sfSymbol(sfSymbol, color: nil))
                }

                HStack(alignment: .firstTextBaseline) {
                    Icon(image: .orbit(.navigateClose))
                    Icon(image: .orbit(.navigateClose), tint: .blueNormal)
                    Icon(image: .orbit(.navigateClose), tint: nil)
                    Icon(.image(.orbit(.navigateClose)))
                    Icon(.image(.orbit(.navigateClose), tint: nil))
                }
            }
            .foregroundColor(.greenNormalHover)
        }
        .previewDisplayName()
    }

    static func size(iconSize: Icon.Size, textSize: Orbit.Text.Size, color: Color) -> some View {
        HStack(spacing: .xSmall) {
            Text("\(Int(iconSize.value))")
                .foregroundColor(color)
                .bold()

            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: iconSize)
                Text("XLarge text and icon size", size: textSize)
            }
            .overlay(Separator(thickness: .hairline), alignment: .top)
            .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }

    static func headingStack(_ style: Heading.Style, alignment: VerticalAlignment) -> some View {
        alignmentStack(style.iconSize, alignment: alignment) {
            Heading("\(style)".capitalized, style: style)
        }
    }

    static func textStack(_ size: Orbit.Text.Size, alignment: VerticalAlignment) -> some View {
        alignmentStack(size.iconSize, alignment: alignment) {
            Text("Text \(Int(size.value))", size: size)
        }
    }

    static func alignmentStack<V: View>(_ size: Icon.Size, alignment: VerticalAlignment, @ViewBuilder content: () -> V) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: alignment, spacing: .xxSmall) {
                Group {
                    Icon(countryCode: "us", size: size)
                    Icon(image: .orbit(.facebook), size: size)
                    Icon(sfSymbol: sfSymbol, size: size)
                    Icon(.informationCircle, size: size)
                    content()
                }
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

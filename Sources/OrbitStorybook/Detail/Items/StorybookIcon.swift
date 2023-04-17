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
                    Icon(sfSymbol, size: .small)
                        .foregroundColor(nil)
                    Icon(sfSymbol, size: .small)
                        .foregroundColor(nil)
                        .baselineOffset(.xxxSmall)

                    Icon(.informationCircle, size: .small)
                        .foregroundColor(nil)
                    Icon(.informationCircle, size: .small)
                        .foregroundColor(nil)
                        .baselineOffset(.xxxSmall)

                    Group {
                        Icon(.orbit(.navigateClose), size: .small)
                            .foregroundColor(nil)
                        Icon(.orbit(.navigateClose), size: .small)
                            .foregroundColor(nil)
                            .baselineOffset(.xxxSmall)
                        Icon(.orbit(.facebook), size: .small)
                        Icon(.orbit(.facebook), size: .small)
                            .baselineOffset(.xxxSmall)
                    }

                    Icon(.countryFlag("us"), size: .small)
                    Icon(.countryFlag("us"), size: .small)
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
                + Icon(sfSymbol, size: .small)
                    .foregroundColor(nil)
                + Icon(sfSymbol, size: .small)
                    .foregroundColor(nil)
                    .baselineOffset(.xxxSmall)

                + Icon(.informationCircle, size: .small)
                    .foregroundColor(nil)
                + Icon(.informationCircle, size: .small)
                    .foregroundColor(nil)
                    .baselineOffset(.xxxSmall)

                + Icon(.orbit(.navigateClose))
                    .foregroundColor(nil)
                + Icon(.orbit(.navigateClose))
                    .foregroundColor(nil)
                    .baselineOffset(.xxxSmall)
                + Icon(.orbit(.facebook))
                + Icon(.orbit(.facebook))
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
                    Icon(.grid)
                        .foregroundColor(.blueNormal)
                    Icon(.grid)
                        .foregroundColor(nil)
                    Icon(.symbol(.grid))
                        .foregroundColor(nil)
                    Icon(.symbol(.grid, color: nil))
                        .foregroundColor(nil)
                }

                HStack(alignment: .firstTextBaseline) {
                    Icon(sfSymbol)
                    Icon(sfSymbol)
                        .foregroundColor(.blueNormal)
                    Icon(sfSymbol)
                        .foregroundColor(nil)
                    Icon(.sfSymbol(sfSymbol))
                        .foregroundColor(nil)
                    Icon(.sfSymbol(sfSymbol))
                        .foregroundColor(nil)
                }

                HStack(alignment: .firstTextBaseline) {
                    Icon(.orbit(.navigateClose))
                    Icon(.orbit(.navigateClose))
                        .foregroundColor(.blueNormal)
                    Icon(.orbit(.navigateClose))
                        .foregroundColor(nil)
                    Icon(.image(.orbit(.navigateClose)))
                        .foregroundColor(nil)
                    Icon(.image(.orbit(.navigateClose)))
                        .foregroundColor(nil)
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
                    Icon(.countryFlag("us"), size: size)
                    Icon(.orbit(.facebook), size: size)
                    Icon(sfSymbol, size: size)
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

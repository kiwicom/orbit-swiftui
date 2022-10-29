import SwiftUI
import Orbit

struct StorybookIcon {

    static let multilineText = "Multiline\nlong\ntext"
    static let sfSymbol = "info.circle.fill"

    static var basic: some View {
        VStack(alignment: .leading, spacing: .medium) {
            snapshotSizes
            snapshotSizesText
            snapshotSizesHeading
            alignments
        }
    }

    static var snapshotSizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            HStack(spacing: .xSmall) {
                Text("16", color: .custom(.redNormal))

                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .small)
                    Text("Small text and icon size", size: .small)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("20", color: .custom(.orangeNormal))

                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .normal)
                    Text("Normal text and icon size", size: .normal)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("24", color: .custom(.greenNormal))

                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .large)
                    Text("Large text and icon size", size: .large)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
        }
    }

    static func headingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .heading(style))
                Heading("Heading", style: style)
            }
            .overlay(Separator(thickness: .hairline), alignment: .top)
            .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }

    static func labelHeadingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Heading", icon: .passengers, style: .heading(style))
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }

    static func labelTextStack(_ size: Orbit.Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Text", icon: .passengers, style: .text(size))
                .overlay(Separator(), alignment: .top)
                .overlay(Separator(), alignment: .bottom)
        }
    }

    static func textStack(_ size: Orbit.Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .text(size))
                Text("Text", size: size)
            }
            .overlay(Separator(), alignment: .top)
            .overlay(Separator(), alignment: .bottom)
        }
    }

    static var snapshotSizesText: some View {
        VStack(alignment: .leading, spacing: .small) {
            textStack(.small)
            textStack(.normal)
            textStack(.large)
            textStack(.xLarge)
            textStack(.custom(50))
        }
        .previewDisplayName("Calculated sizes for Text")
    }

    static var snapshotSizesLabelText: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelTextStack(.small)
            labelTextStack(.normal)
            labelTextStack(.large)
            labelTextStack(.xLarge)
            labelTextStack(.custom(50))
        }
        .previewDisplayName("Calculated sizes for Text in Label")
    }

    static var snapshotSizesHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            headingStack(.title6)
            headingStack(.title5)
            headingStack(.title4)
            headingStack(.title3)
            headingStack(.title2)
            headingStack(.title1)
            headingStack(.displaySubtitle)
            headingStack(.display)
        }
        .previewDisplayName("Calculated sizes for Heading")
    }

    static var snapshotSizesLabelHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelHeadingStack(.title6)
            labelHeadingStack(.title5)
            labelHeadingStack(.title4)
            labelHeadingStack(.title3)
            labelHeadingStack(.title2)
            labelHeadingStack(.title1)
            labelHeadingStack(.displaySubtitle)
            labelHeadingStack(.display)
        }
        .previewDisplayName("Calculated sizes for Heading in Label")
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .small) {
            Text("SF Symbol vs Orbit sizes (custom-font-label)", size: .small)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(sfSymbol: sfSymbol, size: .custom(Text.Size.xLarge.iconSize), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .fontSize(Text.Size.xLarge.value), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .label(.text(.xLarge)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Icon(.informationCircle, size: .custom(Text.Size.xLarge.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.xLarge.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.xLarge)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Text("XLarge", size: .xLarge, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(sfSymbol: sfSymbol, size: .custom(Text.Size.small.iconSize), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .fontSize(Text.Size.small.value), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .label(.text(.small)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Icon(.informationCircle, size: .custom(Text.Size.small.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.small.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.small)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Text("Small", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Flag - Image - SF Symbol sizes", size: .small)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(countryCode: "cz", size: .xLarge)
                    Icon(image: .orbit(.facebook), size: .xLarge)
                    Icon(sfSymbol: sfSymbol, size: .xLarge, color: nil)
                    Text("Text", size: .custom(20), color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(countryCode: "cz", size: .small)
                    Icon(image: .orbit(.facebook), size: .small)
                    Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                    Text("Text", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Baseline alignment", size: .small)
            HStack(alignment: .firstTextBaseline) {
                Group {
                    Text("O", size: .custom(30))
                    Icon(.informationCircle, size: .fontSize(30))
                    Icon(.informationCircle, size: .fontSize(8))
                    Text("O", size: .custom(8))
                    Text("Text", size: .normal)
                }
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Icon color override", size: .small)
            HStack(alignment: .firstTextBaseline) {
                Icon(content: .grid, size: .xLarge)
                Icon(content: .symbol(.grid, color: nil))
                Icon(content: .symbol(.grid, color: .redNormal), size: .text(.small))
                Text("Text", size: .small, color: nil)
            }
            .foregroundColor(.blueDark)
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
        }
    }

    static var alignments: some View {
        VStack(spacing: .medium) {
            HStack(spacing: .medium) {
                HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                    Icon(.grid)
                    Text(multilineText)
                }
                HStack(alignment: .lastTextBaseline, spacing: .xSmall) {
                    Icon(.grid)
                    Text(multilineText)
                }
            }
            Label("Multiline\nlong\nLabel", icon: .grid, style: .text())
        }
    }

    static var baseline: some View {
        VStack(alignment: .leading, spacing: .large) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("Standalone")

                Group {
                    Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: 0)
                    Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: .xxxSmall)
                    Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: -.xxxSmall)

                    Icon(.flightReturn, size: .small, baselineOffset: 0)
                    Icon(.flightReturn, size: .small, baselineOffset: .xxxSmall)
                    Icon(.flightReturn, size: .small, baselineOffset: -.xxxSmall)

                    Icon(countryCode: "us", size: .small, baselineOffset: 0)
                    Icon(countryCode: "us", size: .small, baselineOffset: .xxxSmall)
                    Icon(countryCode: "us", size: .small, baselineOffset: -.xxxSmall)
                }
                .border(Color.cloudLightActive, width: .hairline)
            }

            Text("Concatenated")
                + Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: 0)
                + Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: .xxxSmall)
                + Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: -.xxxSmall)
                + Icon(.flightReturn, size: .small, baselineOffset: 0)
                + Icon(.flightReturn, size: .small, baselineOffset: .xxxSmall)
                + Icon(.flightReturn, size: .small, baselineOffset: -.xxxSmall)
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

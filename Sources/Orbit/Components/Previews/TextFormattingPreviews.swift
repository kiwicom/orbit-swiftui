import SwiftUI

struct TextFormattingPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            regular
            large
        }
    }

    static var regular: some View {
        FormattingTable()
            .padding(.medium)
            .previewDisplayName()
            .previewLayout(.fixed(width: 1050, height: 400))
    }

    static var large: some View {
        FormattingTable()
            .environment(\.sizeCategory, .accessibilityLarge)
            .padding(.medium)
            .previewDisplayName()
            .previewLayout(.fixed(width: 1550, height: 600))
    }

    struct FormattingTable: View {

        let plainText = "Text"
        let markdownText = "Text **str** *ita*"
        let htmlText = "Text <strong>str</strong> <u>und</u> <ref>acc</ref> <applink1>lnk</applink1>"
        let plusText = "+"

        @Environment(\.sizeCategory) var sizeCategory

        var body: some View {
            if #available(iOS 16.0, *) {
                Grid(alignment: .leading, horizontalSpacing: .xMedium, verticalSpacing: .medium) {
                    GridRow(alignment: .top) {
                        nativeTextSmall("Modifiers")
                        nativeTextSmall("Plain")
                        nativeTextSmall("Plain\n(env.)")
                        nativeTextSmall("Formatted")
                        nativeTextSmall("Formatted\n(environment modifiers)")
                        nativeTextSmall("Formatted concatenation")
                        nativeTextSmall("Formatted concatenation\n(environment modifiers)")
                    }
                    .multilineTextAlignment(.leading)

                    referenceRow
                    colorRow
                    boldRow
                    weightRow
                    kerningRow
                    baselineRow
                    mixRow
                }
                .textAccentColor(.orangeNormal)
            }
        }

        @available(iOS 16.0, *)
        @ViewBuilder var colorRow: some View {
            GridRow {
                nativeTextSmall("Color")

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                        .foregroundColor(.blueNormal)
                    text(plainText)
                        .textColor(.blueNormal)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }
                .foregroundColor(.blueNormal)
                .textColor(.blueNormal)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                        .foregroundColor(.blueNormal)
                    text(htmlText)
                        .textColor(.blueNormal)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                }
                .foregroundColor(.blueNormal)
                .textColor(.blueNormal)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText).foregroundColor(.blueNormal)
                    + nplus()
                    + nativeText(markdownText).foregroundColor(.blueNormal)

                    text(plainText).reference()
                    + plus().reference()
                    + text(plainText).textColor(.blueNormal)
                    + plus()
                    + text(htmlText).textColor(.blueNormal)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText)
                    + nplus()
                    + nativeText(markdownText)

                    text(plainText).reference()
                    + plus().reference()
                    + text(plainText)
                    + plus()
                    + text(htmlText)
                }
                .foregroundColor(.blueNormal)
                .textColor(.blueNormal)
            }
        }

        @available(iOS 16.0, *)
        @ViewBuilder var referenceRow: some View {
            GridRow {
                nativeTextSmall("(Unmodified)")

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText)
                    + nplus()
                    + nativeText(markdownText)

                    (
                        text(plainText).reference()
                        + plus().reference()
                        + text(plainText)
                        + plus()
                        + text(htmlText)
                    )
                    .warning()
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText)
                    + nplus()
                    + nativeText(markdownText)

                    (
                        text(plainText).reference()
                        + plus().reference()
                        + text(plainText)
                        + plus()
                        + text(htmlText)
                    )
                    .warning()
                }
            }
        }

        @available(iOS 16.0, *)
        @ViewBuilder var boldRow: some View {
            GridRow {
                nativeTextSmall("Bold")

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                        .bold()
                    text(plainText)
                        .bold()
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }
                .bold()

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                        .bold()
                    text(htmlText)
                        .bold()
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                        .warning()
                }
                .bold()

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText).bold()
                    + nplus()
                    + nativeText(markdownText).bold()

                    text(plainText).reference()
                    + plus().reference()
                    + text(plainText).bold()
                    + plus()
                    + text(htmlText).bold()
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).bold(false).reference()
                    + nplus().bold(false).reference()
                    + nativeText(plainText)
                    + nplus().bold(false)
                    + nativeText(markdownText)

                    text(plainText).bold(false).reference()
                    + plus().bold(false).reference()
                    + text(plainText)
                    + plus().bold(false)
                    + text(htmlText)
                }
                .bold()
            }
        }

        @available(iOS 16.0, *)
        @ViewBuilder var weightRow: some View {
            GridRow {
                nativeTextSmall("Weight")

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                        .fontWeight(.black)
                    text(plainText)
                        .fontWeight(.black)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }
                .fontWeight(.black)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                        .fontWeight(.black)
                    text(htmlText)
                        .fontWeight(.black)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                        .warning()
                }
                .fontWeight(.black)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText).fontWeight(.black)
                    + nplus()
                    + nativeText(markdownText).fontWeight(.black)

                    text(plainText).reference()
                    + plus().reference()
                    + text(plainText).fontWeight(.black)
                    + plus()
                    + text(htmlText).fontWeight(.black)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).fontWeight(.regular).reference()
                    + nplus().fontWeight(.regular).reference()
                    + nativeText(plainText)
                    + nplus().fontWeight(.regular)
                    + nativeText(markdownText)

                    text(plainText).fontWeight(.regular).reference()
                    + plus().fontWeight(.regular).reference()
                    + text(plainText)
                    + plus().fontWeight(.regular)
                    + text(htmlText)
                }
                .fontWeight(.black)
            }
        }

        @available(iOS 16.0, *)
        @ViewBuilder var kerningRow: some View {
            GridRow {
                nativeTextSmall("Kerning")

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                        .kerning(.xxxSmall)
                    text(plainText)
                        .kerning(.xxxSmall)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }
                .kerning(.xxxSmall)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                        .kerning(.xxxSmall)
                    text(htmlText)
                        .kerning(.xxxSmall)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                        .warning()
                }
                .kerning(.xxxSmall)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText).kerning(.xxxSmall)
                    + nplus()
                    + nativeText(markdownText).kerning(.xxxSmall)

                    text(plainText).reference()
                    + plus().reference()
                    + text(plainText).kerning(.xxxSmall)
                    + plus()
                    + text(htmlText).kerning(.xxxSmall)
                }

                VStack(alignment: .leading, spacing: 0) {                            nativeText(plainText).kerning(0).reference()
                    + nplus().kerning(0).reference()
                    + nativeText(plainText)
                    + nplus().kerning(0)
                    + nativeText(markdownText)

                    text(plainText).kerning(0).reference()
                    + plus().kerning(0).reference()
                    + text(plainText)
                    + plus().kerning(0)
                    + text(htmlText)
                }
                .kerning(.xxxSmall)
            }
        }

        @available(iOS 16.0, *)
        @ViewBuilder var baselineRow: some View {
            GridRow {
                VStack(alignment: .leading, spacing: 0) {
                    nativeTextSmall("Baseline")
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                        .baselineOffset(.xxSmall)
                    text(plainText)
                        .baselineOffset(.xxSmall)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }
                .baselineOffset(.xxSmall)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                        .baselineOffset(.xxSmall)
                    text(htmlText)
                        .baselineOffset(.xxSmall)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                }
                .baselineOffset(.xxSmall)

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText).baselineOffset(.xxSmall)
                    + nplus()
                    + nativeText(markdownText).baselineOffset(.xxSmall)

                    text(plainText).reference()
                    + plus().reference()
                    + text(plainText).baselineOffset(.xxSmall)
                    + plus()
                    + text(htmlText).baselineOffset(.xxSmall)
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).baselineOffset(0).reference()
                    + nplus().baselineOffset(0).reference()
                    + nativeText(plainText)
                    + nplus().baselineOffset(0)
                    + nativeText(markdownText)

                    text(plainText).baselineOffset(0).reference()
                    + plus().baselineOffset(0).reference()
                    + text(plainText)
                    + plus().baselineOffset(0)
                    + text(htmlText)
                }
                .baselineOffset(.xxSmall)
            }
        }

        @available(iOS 16.0, *)
        @ViewBuilder var mixRow: some View {
            GridRow {
                VStack(alignment: .leading, spacing: 0) {
                    nativeTextSmall("Color")
                    nativeTextSmall("+Strikethrough")
                    nativeTextSmall("+Underline")
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                        .foregroundColor(.blueNormal)
                        .strikethrough()
                        .underline()
                    text(plainText)
                        .textColor(.blueNormal)
                        .strikethrough()
                        .underline()
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText)
                    text(plainText)
                }
                .foregroundColor(.blueNormal)
                .textColor(.blueNormal)
                .strikethrough()
                .underline()

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                        .foregroundColor(.blueNormal)
                        .strikethrough()
                        .underline()
                    text(htmlText)
                        .textColor(.blueNormal)
                        .strikethrough()
                        .underline()
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(markdownText)
                    text(htmlText)
                }
                .foregroundColor(.blueNormal)
                .textColor(.blueNormal)
                .strikethrough()
                .underline()

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).reference()
                    + nplus().reference()
                    + nativeText(plainText).foregroundColor(.blueNormal).strikethrough().underline()
                    + nplus()
                    + nativeText(markdownText).foregroundColor(.blueNormal).strikethrough().underline()

                    text(plainText).reference()
                    + plus().reference()
                    + text(plainText).textColor(.blueNormal).strikethrough().underline()
                    + plus()
                    + text(htmlText).textColor(.blueNormal).strikethrough().underline()
                }

                VStack(alignment: .leading, spacing: 0) {
                    nativeText(plainText).strikethrough(false).underline(false).reference()
                    + nplus().strikethrough(false).underline(false).reference()
                    + nativeText(plainText)
                    + nplus().strikethrough(false).underline(false)
                    + nativeText(markdownText)

                    text(plainText).strikethrough(false).underline(false).reference()
                    + plus().strikethrough(false).underline(false).reference()
                    + text(plainText)
                    + plus().strikethrough(false).underline(false)
                    + text(htmlText)
                }
                .foregroundColor(.blueNormal)
                .textColor(.blueNormal)
                .strikethrough()
                .underline()
            }
        }

        func text(_ content: String) -> Text {
            Text(content)
                .textSize(custom: 12)
        }

        func plus() -> Text {
            text(plusText)
        }

        func nativeText(_ content: String, size: CGFloat = 12) -> SwiftUI.Text {
            SwiftUI.Text(.init(content))
                .font(.system(size: size * sizeCategory.ratio))
        }

        func nativeTextSmall(_ content: String) -> SwiftUI.Text {
            nativeText(content, size: 8)
        }

        func nplus() -> SwiftUI.Text {
            nativeText(plusText)
        }
    }
}

private extension View {

    @available(iOS 16.0, *)
    func warning() -> some View {
        overlay(
            Icon(.alert)
                .iconSize(custom: 8)
                .textColor(.redNormal)
                .underline(false)
                .baselineOffset(0)
                .kerning(0)
                .offset(x: -.small),
            alignment: .leading
        )
    }
}

private extension SwiftUI.Text {

    func reference() -> SwiftUI.Text {
        foregroundColor(.cloudDark)
    }
}

private extension Text {

    func reference() -> Text {
        textColor(.cloudDark)
    }
}

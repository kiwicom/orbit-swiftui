import SwiftUI
import Orbit

struct StorybookTypography {

    @ViewBuilder static var storybook: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            textSizes
            textMultiline
        }
    }

    @ViewBuilder static var storybookHeading: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            headingSizes
            headingMultiline
        }
    }

    @ViewBuilder static var textSizes: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                text("Text Small", size: .small, weight: .regular)
                text("Text Normal", size: .normal, weight: .regular)
                text("Text Large", size: .large, weight: .regular)
                text("Text Extra Large", size: .xLarge, weight: .regular)
            }

            Separator()

            Group {
                text("Text Medium Small", size: .small, weight: .medium)
                text("Text Medium Normal", size: .normal, weight: .medium)
                text("Text Medium Large", size: .large, weight: .medium)
                text("Text Medium Extra Large", size: .xLarge, weight: .medium)
            }

            Separator()

            Group {
                text("Text Bold Small", size: .small, weight: .bold)
                text("Text Bold Normal", size: .normal, weight: .bold)
                text("Text Bold Large", size: .large, weight: .bold)
                text("Text Bold Extra Large", size: .xLarge, weight: .bold)
            }
        }
        .previewDisplayName("Sizes")
    }

    @ViewBuilder static var textMultiline: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                text("Text Small with a very very very very large and multine content", size: .small, weight: .regular)
                text("Text Normal with a very very very very large and multine content", size: .normal, weight: .regular)
                text("Text Large with a very very very very large and multine content", size: .large, weight: .regular)
                text("Text Extra Large with a very very very very large and multine content", size: .xLarge, weight: .regular)
            }

            Separator()

            Group {
                text("Text Medium Small with a very very very very large and multine content", size: .small, weight: .medium)
                text("Text Medium Normal with a very very very very large and multine content", size: .normal, weight: .medium)
                text("Text Medium Large with a very very very very large and multine content", size: .large, weight: .medium)
                text("Text Medium Extra Large with a very very very very large and multine content", size: .xLarge, weight: .medium)
            }

            Separator()

            Group {
                text("Text Bold Small with a very very very very large and multine content", size: .small, weight: .bold)
                text("Text Bold Normal with a very very very very large and multine content", size: .normal, weight: .bold)
                text("Text Bold Large with a very very very very large and multine content", size: .large, weight: .bold)
                text("Text Bold Extra Large with a very very very very large and multine content", size: .xLarge, weight: .bold)
            }
        }
        .previewDisplayName("Multiline")
    }

    @ViewBuilder static func text(_ content: String, size: Orbit.Text.Size, weight: Font.Weight) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text(content, size: size, weight: weight)
            Spacer()
            Text("\(Int(size.value))/\(Int(size.lineHeight))", color: .inkNormal, weight: .medium)
        }
    }

    static var headingSizes: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("Display Title", style: .display)
            heading("Display Subtitle", style: .displaySubtitle)
            Separator()
                .padding(.vertical, .small)
            heading("Title 1", style: .title1)
            heading("Title 2", style: .title2)
            heading("Title 3", style: .title3)
            heading("Title 4", style: .title4)
            heading("Title 5", style: .title5)
            heading("Title 6", style: .title6)
        }
    }

    static var headingMultiline: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            heading("Display title with a very large and multine content", style: .display)
            heading("Display subtitle with a very large and multine content", style: .displaySubtitle)
            Separator()
                .padding(.vertical, .small)
            heading("Title 1 with a very large and multine content", style: .title1)
            heading("Title 2 with a very very large and multine content", style: .title2)
            heading("Title 3 with a very very very very large and multine content", style: .title3)
            heading("Title 4 with a very very very very large and multine content", style: .title4)
            heading("Title 5 with a very very very very very large and multine content", style: .title5)
            heading("Title 6 with a very very very very very large and multine content", style: .title6)
        }
        .previewDisplayName("Multiline")
    }

    @ViewBuilder static func heading(_ content: String, style: Heading.Style) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Heading(content, style: style)
            Spacer()
            Text("\(Int(style.size))/\(Int(style.lineHeight))", color: .inkNormal, weight: .medium)
        }
    }
}

struct StorybookTypographyPreviews: PreviewProvider {
    
    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTypography.storybook
            StorybookTypography.storybookHeading
        }
        .previewLayout(.sizeThatFits)
    }
}

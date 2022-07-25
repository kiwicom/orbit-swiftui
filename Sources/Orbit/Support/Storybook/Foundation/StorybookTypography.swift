import SwiftUI

struct StorybookTypography {

    @ViewBuilder static var storybook: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            TextPreviews.sizes
            TextPreviews.multiline
        }
    }

    @ViewBuilder static var storybookHeading: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            HeadingPreviews.sizes
            HeadingPreviews.multiline
        }
    }
}

struct StorybookTypographyPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            StorybookTypography.storybook
            StorybookTypography.storybookHeading
        }
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI
import Orbit

struct StorybookIllustrations {

    static var illustrations: [Illustration.Image] {
        Array(Illustration.Image.allCases.dropFirst())
    }

    @ViewBuilder static func storybook(filter: String = "") -> some View {
        LazyVStack(alignment: .leading, spacing: .xSmall) {
            stackContent(filter: filter)
        }
    }

    @ViewBuilder static func stackContent(filter: String) -> some View {
        ForEach(0 ... illustrations(filter: filter).count / 2, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .xSmall) {
                illustration(index: rowIndex * 2, filter: filter)
                illustration(index: rowIndex * 2 + 1, filter: filter)
            }
        }
    }

    @ViewBuilder static func illustration(index: Int, filter: String) -> some View {
        if let illustration = illustrationImage(index: index, filter: filter) {
            VStack(spacing: .xxSmall) {
                Illustration(illustration, layout: .resizeable)
                    .frame(height: 150)
                Text(String(describing: illustration).titleCased, size: .small, color: .inkNormal, isSelectable: true)
            }
            .padding(.horizontal, .xxSmall)
            .padding(.vertical, .xSmall)
            .frame(maxWidth: .infinity)
            .background(Color.whiteDarker)
            .tileBorder(.plain)
        } else {
            Color.whiteDarker
                .frame(height: 1)
                .padding(.horizontal, .xxSmall)
                .padding(.vertical, .xSmall)
                .frame(maxWidth: .infinity)

        }
    }

    static func illustrations(filter: String) -> [Illustration.Image] {
        illustrations.filter { filter.isEmpty || "\($0)".localizedCaseInsensitiveContains(filter) }
    }

    static func illustrationImage(index: Int, filter: String) -> Illustration.Image? {
        let filteredImages = illustrations(filter: filter)
        guard filteredImages.indices.contains(index) else {
            return nil
        }
        return filteredImages[index]
    }
}

struct StorybookIllustrationsPreviews: PreviewProvider {
    
    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookIllustrations.storybook()
        }
    }
}

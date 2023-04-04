import SwiftUI
import Orbit

struct StorybookSeparator {

    static var basic: some View {
        VStack(spacing: .xLarge) {
            Separator()
            Separator("Separator with label")
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .xLarge) {
            Separator("Custom colors", labelColor: .productDark, color: .blueNormal)
            Separator("Separator with very very very very very long and multiline label")
            Separator("Hairline thickness", thickness: .hairline)
            Separator("Custom thickness", thickness: .custom(.xSmall))
        }
        .previewDisplayName()
    }
}

struct StorybookSeparatorPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookSeparator.basic
            StorybookSeparator.mix
        }
    }
}

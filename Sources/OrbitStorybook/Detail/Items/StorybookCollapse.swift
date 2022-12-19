import SwiftUI
import Orbit

struct StorybookCollapse {

    static var basic: some View {
        VStack(spacing: 0) {
            StateWrapper(initialState: false) { isExpanded in
                Collapse("Toggle content (collapsed)", isExpanded: isExpanded) {
                    contentPlaceholder
                }
            }
            StateWrapper(initialState: true) { isExpanded in
                Collapse("Toggle content (expanded)", isExpanded: isExpanded) {
                    contentPlaceholder
                }
            }
            Collapse {
                contentPlaceholder
            } headerContent: {
                headerPlaceholder
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
}

struct StorybookCollapsePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCollapse.basic
        }
    }
}

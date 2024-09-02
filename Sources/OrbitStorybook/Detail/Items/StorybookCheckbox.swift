import SwiftUI
import Orbit

struct StorybookCheckbox {

    static let label = "Label"
    static let description = "Additional information<br>for this choice"

    static var basic: some View {
        VStack(alignment: .leading, spacing: .large) {
            content(standalone: false)
            content(standalone: true)
        }
        .previewDisplayName()
    }

    static func content(standalone: Bool) -> some View {
        HStack(alignment: .top, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .xLarge) {
                checkbox(standalone: standalone, checked: false)
                checkbox(standalone: standalone, state: .error, checked: false)
                checkbox(standalone: standalone, checked: false)
                    .disabled(true)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                checkbox(standalone: standalone, checked: true)
                checkbox(standalone: standalone, state: .error, checked: true)
                checkbox(standalone: standalone, checked: true)
                    .disabled(true)
            }
        }
    }

    static func checkbox(standalone: Bool, state: CheckboxState = .normal, checked: Bool) -> some View {
        StateWrapper(checked) { isChecked in
            Checkbox(
                standalone ? "" : label,
                description: standalone ? "" : description,
                isChecked: isChecked,
                state: state
            )
        }
    }
}

struct StorybookCheckboxPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookCheckbox.basic
        }
    }
}

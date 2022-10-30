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
    }

    static func content(standalone: Bool) -> some View {
        HStack(alignment: .top, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .xLarge) {
                checkbox(standalone: standalone, state: .normal, checked: false)
                checkbox(standalone: standalone, state: .error, checked: false)
                checkbox(standalone: standalone, state: .disabled, checked: false)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                checkbox(standalone: standalone, state: .normal, checked: true)
                checkbox(standalone: standalone, state: .error, checked: true)
                checkbox(standalone: standalone, state: .disabled, checked: true)
            }
        }
    }

    static func checkbox(standalone: Bool, state: Checkbox.State, checked: Bool) -> some View {
        StateWrapper(initialState: checked) { isSelected in
            Checkbox(
                standalone ? "" : label,
                description: standalone ? "" : description,
                state: state,
                isChecked: isSelected.wrappedValue
            ) {
                isSelected.wrappedValue.toggle()
            }
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

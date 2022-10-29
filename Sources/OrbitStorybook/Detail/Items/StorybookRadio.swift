import SwiftUI
import Orbit

struct StorybookRadio {

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
                radio(standalone: standalone, state: .normal, checked: false)
                radio(standalone: standalone, state: .error, checked: false)
                radio(standalone: standalone, state: .disabled, checked: false)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                radio(standalone: standalone, state: .normal, checked: true)
                radio(standalone: standalone, state: .error, checked: true)
                radio(standalone: standalone, state: .disabled, checked: true)
            }
        }
    }

    static func radio(standalone: Bool, state: Radio.State, checked: Bool) -> some View {
        StateWrapper(initialState: checked) { isSelected in
            Radio(standalone ? "" : label, description: standalone ? "" : description, state: state, isChecked: isSelected.wrappedValue) {
                isSelected.wrappedValue.toggle()
            }
        }
    }
}

struct StorybookRadioPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookRadio.basic
        }
    }
}

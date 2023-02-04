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
        .previewDisplayName()
    }

    static func content(standalone: Bool) -> some View {
        HStack(alignment: .top, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .xLarge) {
                radio(standalone: standalone, checked: false)
                radio(standalone: standalone, state: .error, checked: false)
                radio(standalone: standalone, checked: false)
                    .disabled(true)
            }

            VStack(alignment: .leading, spacing: .xLarge) {
                radio(standalone: standalone, checked: true)
                radio(standalone: standalone, state: .error, checked: true)
                radio(standalone: standalone, checked: true)
                    .disabled(true)
            }
        }
    }

    static func radio(standalone: Bool, state: Radio.State = .normal, checked: Bool) -> some View {
        StateWrapper(checked) { isChecked in
            Radio(standalone ? "" : label, description: standalone ? "" : description, state: state, isChecked: isChecked)
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

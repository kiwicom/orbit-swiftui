import SwiftUI
import Orbit

struct StorybookSegmentedSwitch {

    static var basic: some View {
        VStack(spacing: .large) {
            segmentedSwitch()
            segmentedSwitch(selection: "Male")
            segmentedSwitch(message: .help("Help message"))
            segmentedSwitch(message: .error("Error message"))
        }
        .previewDisplayName()
    }

    static func segmentedSwitch(
        selection: String? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        label: String = "Gender",
        message: Message? = nil
    ) -> some View {
        StateWrapper(initialState: selection) { value in
            SegmentedSwitch(
                label: label,
                firstOption: firstOption,
                secondOption: secondOption,
                selection: value,
                message: message
            )
        }
    }
}

struct StorybookSegmentedSwitchPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookSegmentedSwitch.basic
        }
    }
}

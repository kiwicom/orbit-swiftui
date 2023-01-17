import SwiftUI
import Orbit

struct StorybookSegmentedSwitch {

    static var basic: some View {
        VStack(spacing: .large) {
            segmentedSwitch()
            segmentedSwitch(selectedIndex: 0)
            segmentedSwitch(message: .help("Help message"))
            segmentedSwitch(message: .error("Error message"))
        }
        .previewDisplayName()
    }

    static func segmentedSwitch(
        selectedIndex: Int? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        label: String = "Gender",
        message: Message? = nil
    ) -> some View {
        StateWrapper(selectedIndex) { value in
            SegmentedSwitch(
                label,
                firstOption: firstOption,
                secondOption: secondOption,
                selectedIndex: value,
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

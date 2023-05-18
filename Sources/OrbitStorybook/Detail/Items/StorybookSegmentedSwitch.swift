import SwiftUI
import Orbit

struct StorybookSegmentedSwitch {

    static var basic: some View {
        VStack(spacing: .large) {
            segmentedSwitch()
            segmentedSwitch(selection: 0)
            segmentedSwitch(message: .help("Help message"))
            segmentedSwitch(message: .error("Error message"))
        }
        .previewDisplayName()
    }

    static func segmentedSwitch(
        selection: Int? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        label: String = "Gender",
        message: Message? = nil
    ) -> some View {
        StateWrapper(selection) { value in
            SegmentedSwitch(
                label,
                selection: value,
                message: message
            ) {
                Text(firstOption)
                    .identifier(0)

                Text(secondOption)
                    .identifier(1)
            }
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

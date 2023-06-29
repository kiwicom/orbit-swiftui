import SwiftUI
import Orbit

struct StorybookSegmentedSwitch {

    static var basic: some View {
        VStack(spacing: .large) {
            binarySegmentedSwitch()
            threeOptionsSegmentedSwitch()
            binarySegmentedSwitch(selection: 0)
            threeOptionsSegmentedSwitch(selection: 0)
            binarySegmentedSwitch(message: .help("Help message"))
            threeOptionsSegmentedSwitch(message: .help("Help message"))
            binarySegmentedSwitch(message: .error("Error message"))
            threeOptionsSegmentedSwitch(message: .error("Error message"))
        }
        .previewDisplayName()
    }

    static func binarySegmentedSwitch(
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

    static func threeOptionsSegmentedSwitch(
        selection: Int? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        thirdOption: String = "Non-binary",
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

                Text(thirdOption)
                    .identifier(2)
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

import XCTest
@testable import Orbit

class ButtonTests: SnapshotTestCase {

    func testButtons() {
        assert(ButtonPreviews.standalone)
        assert(ButtonPreviews.sizing)
        assert(ButtonPreviews.storybook)
        assert(ButtonPreviews.storybookStatus)
        assert(ButtonPreviews.storybookGradient)
    }
}

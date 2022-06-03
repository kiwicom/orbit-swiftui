import XCTest
@testable import Orbit

class ButtonLinkTests: SnapshotTestCase {

    func testButtonLinks() {
        assert(ButtonLinkPreviews.standalone)
        assert(ButtonLinkPreviews.sizing)
        assert(ButtonLinkPreviews.storybook)
        assert(ButtonLinkPreviews.storybookStatus)
        assert(ButtonLinkPreviews.storybookSizes)
    }
}

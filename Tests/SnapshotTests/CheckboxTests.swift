import XCTest
@testable import Orbit

class CheckboxTests: SnapshotTestCase {

    func testCheckboxes() {
        assert(CheckboxPreviews.standalone)
        assert(CheckboxPreviews.storybook)
    }
}

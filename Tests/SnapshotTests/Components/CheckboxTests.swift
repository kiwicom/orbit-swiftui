import XCTest
@testable import Orbit

class CheckboxTests: SnapshotTestCase {

    func testCheckboxes() {
        assert(CheckboxPreviews.snapshot)
    }
}

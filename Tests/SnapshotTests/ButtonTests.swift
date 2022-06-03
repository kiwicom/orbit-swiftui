import XCTest
@testable import Orbit

class ButtonTests: SnapshotTestCase {

    func testButtons() {
        assert(ButtonPreviews.snapshot)
    }
}

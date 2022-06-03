import XCTest
@testable import Orbit

class ButtonLinkTests: SnapshotTestCase {

    func testButtonLinks() {
        assert(ButtonLinkPreviews.snapshot)
    }
}

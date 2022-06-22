import XCTest
@testable import Orbit

class HorizontalScrollTests: SnapshotTestCase {

    func testHorizontalScrolls() {
        assert(HorizontalScrollPreviews.snapshot)
    }
}

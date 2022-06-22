import XCTest
@testable import Orbit

class HeadingTests: SnapshotTestCase {

    func testHeadings() {
        assert(HeadingPreviews.snapshot)
    }
}

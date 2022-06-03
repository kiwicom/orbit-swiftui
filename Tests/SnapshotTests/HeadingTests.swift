import XCTest
@testable import Orbit

class HeadingTests: SnapshotTestCase {

    func testHeadings() {
        assert(HeadingPreviews.standalone)
        assert(HeadingPreviews.sizes)
        assert(HeadingPreviews.multiline)
    }
}

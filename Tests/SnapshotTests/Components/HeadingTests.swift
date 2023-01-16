import XCTest
@testable import Orbit

class HeadingTests: SnapshotTestCase {

    func testHeadings() {
        assert(HeadingPreviews.formatted)
        assert(HeadingPreviews.lineHeight)
        assert(HeadingPreviews.lineSpacing)
    }
}

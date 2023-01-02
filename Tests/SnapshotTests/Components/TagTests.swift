import XCTest
@testable import Orbit

class TagTests: SnapshotTestCase {

    func testTags() {
        assert(TagPreviews.styles)
        assert(TagPreviews.sizing)
    }
}

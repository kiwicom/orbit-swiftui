import XCTest
@testable import Orbit

class TagTests: SnapshotTestCase {

    func testTags() {
        assert(TagPreviews.standalone)
        assert(TagPreviews.sizing)
        assert(TagPreviews.storybook)
    }
}

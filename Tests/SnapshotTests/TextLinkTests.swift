import XCTest
@testable import Orbit

class TextLinkTests: SnapshotTestCase {

    func testTextLinks() {
        assert(TextLinkPreviews.standalone)
        assert(TextLinkPreviews.storybook)
    }
}

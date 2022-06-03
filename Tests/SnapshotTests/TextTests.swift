import XCTest
@testable import Orbit

class TextTests: SnapshotTestCase {

    func testTexts() {
        assert(TextPreviews.standalone)
        assert(TextPreviews.storybook)
        assert(TextPreviews.sizes)
        assert(TextPreviews.multiline)
        assert(TextPreviews.custom)
        assert(TextPreviews.attributedTextSnapshots)
        assert(TextPreviews.snapshotsSizing)
    }
}

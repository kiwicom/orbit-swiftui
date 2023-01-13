import XCTest
@testable import Orbit

class TextTests: SnapshotTestCase {

    func testTexts() {
        assert(TextPreviews.formatting)
        assert(TextPreviews.lineHeight)
        assert(TextPreviews.lineSpacing)
    }
}

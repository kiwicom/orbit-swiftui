import XCTest
@testable import Orbit

class TextTests: SnapshotTestCase {

    func testTexts() {
        assert(TextPreviews.multilineFormatting)
        assert(TextPreviews.lineHeight)
        assert(TextPreviews.lineSpacing)
        assert(TextPreviews.standalone)
        assert(TextFormattingPreviews.regular, size: .intrinsic)
        assert(TextFormattingPreviews.large, size: .intrinsic)
    }
}

import XCTest
@testable import Orbit

class TextTests: SnapshotTestCase {

    func testTexts() {
        assert(TextPreviews.snapshot)
    }
}

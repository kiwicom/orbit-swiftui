import XCTest
@testable import Orbit

class TextConcatenationTests: SnapshotTestCase {

    func testTextConcatenation() {
        assert(TextConcatenationPreviews.snapshot)
    }
}

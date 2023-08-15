import XCTest
@testable import Orbit

class InputContentTests: SnapshotTestCase {

    func testInputContent() {
        assert(InputContentPreviews.standalone)
        assert(InputContentPreviews.sizing)
    }
}

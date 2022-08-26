import XCTest
@testable import Orbit

class DialogTests: SnapshotTestCase {

    func testDialog() {
        assert(DialogPreviews.snapshot)
    }
}

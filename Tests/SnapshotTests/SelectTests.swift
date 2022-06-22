import XCTest
@testable import Orbit

class SelectTests: SnapshotTestCase {

    func testSelects() {
        assert(SelectPreviews.snapshot)
    }
}

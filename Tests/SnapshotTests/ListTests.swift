import XCTest
@testable import Orbit

class ListTests: SnapshotTestCase {

    func testList() {
        assert(ListPreviews.snapshot)
    }
}

import XCTest
@testable import Orbit

class EmptyStateTests: SnapshotTestCase {

    func testEmptyStates() {
        assert(EmptyStatePreviews.snapshot)
    }
}

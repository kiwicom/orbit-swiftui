import XCTest
@testable import Orbit

class EmptyStateTests: SnapshotTestCase {

    func testEmptyStates() {
        assert(EmptyStatePreviews.standalone)
        assert(EmptyStatePreviews.subtle)
        assert(EmptyStatePreviews.noAction)
    }
}

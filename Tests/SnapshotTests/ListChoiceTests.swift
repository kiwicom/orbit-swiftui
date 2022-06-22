import XCTest
@testable import Orbit

class ListChoiceTests: SnapshotTestCase {

    func testListChoices() {
        assert(ListChoicePreviews.snapshot)
    }
}

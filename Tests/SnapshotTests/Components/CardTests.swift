import XCTest
@testable import Orbit

class CardTests: SnapshotTestCase {

    func testCards() {
        assert(CardPreviews.snapshot)
    }
}

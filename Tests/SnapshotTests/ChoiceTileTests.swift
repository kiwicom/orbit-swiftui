import XCTest
@testable import Orbit

class ChoiceTileTests: SnapshotTestCase {

    func testChoiceTiles() {
        assert(ChoiceTilePreviews.snapshot)
    }
}

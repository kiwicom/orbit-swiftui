import XCTest
@testable import Orbit

class TileTests: SnapshotTestCase {

    func testTiles() {
        assert(TilePreviews.snapshot)
    }
}

import XCTest
@testable import Orbit

class TileTests: SnapshotTestCase {

    func testTiles() {
        assert(TilePreviews.tiles)
        assert(TilePreviews.sizing)
        assert(TilePreviews.idealSize)
    }
}

import XCTest
@testable import Orbit

class TileGroupTests: SnapshotTestCase {

    func testTileGroups() {
        assert(TileGroupPreviews.snapshot)
    }
}

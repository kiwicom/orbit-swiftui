import XCTest
@testable import Orbit

class TileTests: SnapshotTestCase {

    func testTiles() {
        assert(TilePreviews.standalone)
        assert(TilePreviews.sizing)
        assert(TilePreviews.storybook)
        assert(TilePreviews.storybookMix)
    }
}

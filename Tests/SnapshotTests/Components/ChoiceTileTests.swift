import XCTest
@testable import Orbit

class ChoiceTileTests: SnapshotTestCase {

    func testChoiceTiles() {
        assert(ChoiceTilePreviews.standalone)
        assert(ChoiceTilePreviews.standaloneCentered)
        assert(ChoiceTilePreviews.sizing)
        assert(ChoiceTilePreviews.intrinsic)
    }
}

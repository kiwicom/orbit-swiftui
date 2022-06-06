import XCTest
@testable import Orbit

class ChoiceTileTests: SnapshotTestCase {

    func testChoiceTiles() {
        assert(ChoiceTilePreviews.standalone)
        assert(ChoiceTilePreviews.storybook)
        assert(ChoiceTilePreviews.storybookCentered)
        assert(ChoiceTilePreviews.storybookMix)
    }
}

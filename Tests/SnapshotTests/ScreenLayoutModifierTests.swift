import XCTest
@testable import Orbit

class ScreenLayoutModifierTests: SnapshotTestCase {

    func testScreenLayoutModifier() {
        assert(ScreenLayoutModifierPreviews.snapshot)
    }
}

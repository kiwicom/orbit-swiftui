import XCTest
@testable import Orbit

class IconTests: SnapshotTestCase {

    func testIcons() {
        assert(IconPreviews.snapshot)
    }
}

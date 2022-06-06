import XCTest
@testable import Orbit

class IconTests: SnapshotTestCase {

    func testIcons() {
        assert(IconPreviews.standalone)
        assert(IconPreviews.snapshotSizes)
        assert(IconPreviews.snapshotSizesText)
        assert(IconPreviews.snapshotSizesLabelText)
        assert(IconPreviews.snapshotSizesHeading)
        assert(IconPreviews.snapshotSizesLabelHeading)
    }
}

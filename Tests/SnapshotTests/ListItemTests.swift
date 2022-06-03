import XCTest
@testable import Orbit

class ListItemTests: SnapshotTestCase {

    func testListItems() {
        assert(ListItemPreviews.snapshots)
        assert(ListItemPreviews.snapshotsLinks)
        assert(ListItemPreviews.snapshotsCustom)
    }
}

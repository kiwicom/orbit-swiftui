import XCTest
@testable import Orbit

class CollapseTests: SnapshotTestCase {

    func testCollapse() {
        assert(CollapsePreviews.snapshot)
    }
}

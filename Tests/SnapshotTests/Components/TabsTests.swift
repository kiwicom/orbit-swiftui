import XCTest
@testable import Orbit

class TabsTests: SnapshotTestCase {

    func testTabs() {
        assert(TabsPreviews.snapshot)
        assert(TabsPreviews.sizing)
    }
}

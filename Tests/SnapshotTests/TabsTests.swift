import XCTest
@testable import Orbit

class TabsTests: SnapshotTestCase {

    func testTabs() {
        assert(TabsPreviews.standalone)
        assert(TabsPreviews.product)
        assert(TabsPreviews.equalSingleline)
        assert(TabsPreviews.equalMultiline)
        assert(TabsPreviews.intrinsicSingleline)
        assert(TabsPreviews.intrinsicMultiline)
    }
}

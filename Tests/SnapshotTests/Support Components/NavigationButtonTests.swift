import XCTest
@testable import Orbit

class NavigationButtonTests: SnapshotTestCase {

    func testNavigationButtonBack() {
        assert(NavigationButtonPreviews.navigationBack, size: .deviceSize)
    }

    func testNavigationButtonClose() {
        assert(NavigationButtonPreviews.navigationClose, size: .deviceSize)
    }
}

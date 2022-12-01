import XCTest
@testable import Orbit

class BarButtonTests: SnapshotTestCase {

    func testBarButton() {
        assert(BarButtonPreviews.navigationView, size: .deviceSize)
    }
}

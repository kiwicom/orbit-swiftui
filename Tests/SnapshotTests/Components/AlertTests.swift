import XCTest
@testable import Orbit

class AlertTests: SnapshotTestCase {

    func testAlerts() {
        assert(AlertPreviews.snapshot)
    }
}

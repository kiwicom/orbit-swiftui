import XCTest
@testable import Orbit

class AlertTests: SnapshotTestCase {

    func testAlerts() {
        assert(AlertPreviews.standalone)
        assert(AlertPreviews.basic)
        assert(AlertPreviews.basicNoIcon)
        assert(AlertPreviews.suppressed)
        assert(AlertPreviews.suppressedNoIcon)
        assert(AlertPreviews.primaryButtonOnly)
        assert(AlertPreviews.noButtons)
    }
}

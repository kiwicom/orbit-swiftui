import XCTest
@testable import Orbit

class AlertInlineTests: SnapshotTestCase {

    func testAlerts() {
        assert(AlertInlinePreviews.snapshot)
    }
}

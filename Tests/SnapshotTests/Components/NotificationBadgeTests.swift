import XCTest
@testable import Orbit

class NotificationBadgeTests: SnapshotTestCase {

    func testNotificationBadges() {
        assert(NotificationBadgePreviews.styles)
        assert(NotificationBadgePreviews.sizing)
    }
}

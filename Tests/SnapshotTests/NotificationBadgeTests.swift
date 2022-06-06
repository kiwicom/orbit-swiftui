import XCTest
@testable import Orbit

class NotificationBadgeTests: SnapshotTestCase {

    func testNotificationBadges() {
        assert(NotificationBadgePreviews.standalone)
        assert(NotificationBadgePreviews.sizing)
        assert(NotificationBadgePreviews.storybook)
        assert(NotificationBadgePreviews.storybookMix)
        assert(NotificationBadgePreviews.storybookGradient)
    }
}

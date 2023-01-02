import XCTest
@testable import Orbit

class BadgeTests: SnapshotTestCase {

    func testBadges() {
        assert(BadgePreviews.statuses)
        assert(BadgePreviews.sizing)
    }
}

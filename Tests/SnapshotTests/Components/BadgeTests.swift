import XCTest
@testable import Orbit

class BadgeTests: SnapshotTestCase {

    func testBadges() {
        assert(BadgePreviews.styles)
        assert(BadgePreviews.sizing)
    }
}

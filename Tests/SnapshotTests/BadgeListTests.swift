import XCTest
@testable import Orbit

class BadgeListTests: SnapshotTestCase {

    func testBadgeLists() {
        assert(BadgeListPreviews.standalone)
        assert(BadgeListPreviews.storybook)
    }
}

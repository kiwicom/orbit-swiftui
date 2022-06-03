import XCTest
@testable import Orbit

class BadgeTests: SnapshotTestCase {

    func testBadges() {
        assert(BadgePreviews.standalone)
        assert(BadgePreviews.sizing)
        assert(BadgePreviews.storybook)
        assert(BadgePreviews.storybookMix)
        assert(BadgePreviews.storybookGradient)
    }
}

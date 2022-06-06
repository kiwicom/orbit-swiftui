import XCTest
@testable import Orbit

class TimelineTests: SnapshotTestCase {

    func testTimeline() {
        assert(TimelinePreviews.standalone)
        assert(TimelinePreviews.storybook)
        assert(TimelinePreviews.storybookMix)
    }
}

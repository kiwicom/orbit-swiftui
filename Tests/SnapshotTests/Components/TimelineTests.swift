import XCTest
@testable import Orbit

class TimelineTests: SnapshotTestCase {

    func testTimeline() {
        assert(TimelinePreviews.snapshot)
    }

    func testTimelineItem() {
        assert(TimelineItemPreviews.snapshots)
    }
}

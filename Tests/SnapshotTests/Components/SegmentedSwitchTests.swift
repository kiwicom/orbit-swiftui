import XCTest
@testable import Orbit

class SegmentedSwitchTests: SnapshotTestCase {

    func testSegmentedSwitch() {
        assert(SegmentedSwitchPreviews.snapshot)
    }
}

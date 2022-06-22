import XCTest
@testable import Orbit

class SwitchTests: SnapshotTestCase {

    func testSwitches() {
        assert(SwitchPreviews.snapshot)
    }
}

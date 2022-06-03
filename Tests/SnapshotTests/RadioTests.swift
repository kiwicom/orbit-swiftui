import XCTest
@testable import Orbit

class RadioTests: SnapshotTestCase {

    func testRadios() {
        assert(RadioPreviews.snapshot)
    }
}

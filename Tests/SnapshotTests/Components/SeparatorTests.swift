import XCTest
@testable import Orbit

class SeparatorTests: SnapshotTestCase {

    func testSeparators() {
        assert(SeparatorPreviews.snapshot)
    }
}

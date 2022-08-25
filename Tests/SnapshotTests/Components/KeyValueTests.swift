import XCTest
@testable import Orbit

class KeyValueTests: SnapshotTestCase {

    func testKeyValues() {
        assert(KeyValuePreviews.snapshot)
    }
}

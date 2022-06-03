import XCTest
@testable import Orbit

class KeyValueTests: SnapshotTestCase {

    func testKeyValues() {
        assert(KeyValuePreviews.standalone)
        assert(KeyValuePreviews.storybook)
    }
}

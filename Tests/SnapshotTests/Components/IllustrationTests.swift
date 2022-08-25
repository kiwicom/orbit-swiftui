import XCTest
@testable import Orbit

class IllustrationTests: SnapshotTestCase {

    func testIllustrations() {
        assert(IllustrationPreviews.snapshot)
    }
}

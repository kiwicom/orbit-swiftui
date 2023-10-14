import XCTest
@testable import Orbit
@testable import OrbitIllustrations

class IllustrationTests: SnapshotTestCase {

    func testIllustrations() {
        assert(IllustrationPreviews.snapshot)
    }
}

import XCTest
@testable import Orbit

class IllustrationTests: SnapshotTestCase {

    func testIllustrations() {
        assert(IllustrationPreviews.standalone)
        assert(IllustrationPreviews.intrinsic)
        assert(IllustrationPreviews.snapshotsSizing)
        assert(IllustrationPreviews.snapshotsExpanding)
    }
}

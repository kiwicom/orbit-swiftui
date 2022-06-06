import XCTest
@testable import Orbit

class DialogTests: SnapshotTestCase {

    func testDialog() {
        assert(DialogPreviews.normal)
        assert(DialogPreviews.critical)
        assert(DialogPreviews.titleOnly)
        assert(DialogPreviews.descriptionOnly)
    }
}

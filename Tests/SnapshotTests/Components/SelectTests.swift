import XCTest
@testable import Orbit

class SelectTests: SnapshotTestCase {

    func testSelects() {
        assert(SelectPreviews.styles)
        assert(SelectPreviews.sizing)
        assert(SelectPreviews.intrinsic)
    }
}

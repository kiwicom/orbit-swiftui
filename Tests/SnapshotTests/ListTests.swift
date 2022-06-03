import XCTest
@testable import Orbit

class ListTests: SnapshotTestCase {

    func testList() {
        assert(ListPreviews.standalone)
        assert(ListPreviews.storybook)
        assert(ListPreviews.storybookMix)
    }
}

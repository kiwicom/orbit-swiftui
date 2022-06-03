import XCTest
@testable import Orbit

class SeparatorTests: SnapshotTestCase {

    func testSeparators() {
        assert(SeparatorPreviews.standalone)
        assert(SeparatorPreviews.storybook)
        assert(SeparatorPreviews.storybookMix)
    }
}

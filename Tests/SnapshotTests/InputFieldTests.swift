import XCTest
@testable import Orbit

class InputFieldTests: SnapshotTestCase {

    func testInputFields() {
        assert(InputFieldPreviews.standalone)
        assert(InputFieldPreviews.storybook)
        assert(InputFieldPreviews.storybookMix)
    }
}

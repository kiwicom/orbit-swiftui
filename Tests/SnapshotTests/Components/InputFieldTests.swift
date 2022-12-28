import XCTest
@testable import Orbit

class InputFieldTests: SnapshotTestCase {

    func testInputFields() {
        assert(InputFieldPreviews.styles)
        assert(InputFieldPreviews.sizing)
    }

    func testInputFieldsPassword() {
        assert(InputFieldPreviews.password)
    }
}

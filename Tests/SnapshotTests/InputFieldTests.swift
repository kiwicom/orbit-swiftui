import XCTest
@testable import Orbit

class InputFieldTests: SnapshotTestCase {

    func testInputFields() {
        assert(InputFieldPreviews.snapshot)
    }
}

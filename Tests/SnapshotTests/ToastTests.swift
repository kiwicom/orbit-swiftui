import XCTest
@testable import Orbit

class ToastTests: SnapshotTestCase {

    func testToasts() {
        assert(ToastPreviews.standaloneWrapper)
        assert(ToastPreviews.storybook)
    }
}

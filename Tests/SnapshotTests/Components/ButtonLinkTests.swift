import XCTest
@testable import Orbit

class ButtonLinkTests: SnapshotTestCase {

    func testButtonLinks() {
        assert(ButtonLinkPreviews.styles)
        assert(ButtonLinkPreviews.sizing)
    }
}

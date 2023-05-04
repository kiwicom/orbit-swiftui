import XCTest
@testable import Orbit

final class SliderTests: SnapshotTestCase {

    func testSlider() {
        assert(SliderPreviews.snapshot)
    }
}

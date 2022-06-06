import XCTest
@testable import Orbit

class HorizontalScrollTests: SnapshotTestCase {

    func testHorizontalScrolls() {
        assert(HorizontalScrollPreviews.simpleSmallRatio)
        assert(HorizontalScrollPreviews.simpleCustom)
        assert(HorizontalScrollPreviews.ratioWidthIntrinsicHeight)
        assert(HorizontalScrollPreviews.smallRatioWidthIntrinsicHeight)
        assert(HorizontalScrollPreviews.fullWidthIntrinsicHeight)
        assert(HorizontalScrollPreviews.intrinsic)
        assert(HorizontalScrollPreviews.custom)
    }
}

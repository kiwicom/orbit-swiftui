import XCTest
@testable import Orbit

class SkeletonTests: SnapshotTestCase {

    func testSkeletons() {
        assert(SkeletonPreviews.storybook)
        assert(SkeletonPreviews.storybookAtomic)
    }
}

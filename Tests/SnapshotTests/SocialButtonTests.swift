import XCTest
@testable import Orbit

class SocialButtonTests: SnapshotTestCase {

    func testSocialButtons() {
        assert(SocialButtonPreviews.standalone)
        assert(SocialButtonPreviews.storybook)
    }
}

import XCTest
@testable import Orbit

class ListChoiceTests: SnapshotTestCase {

    func testListChoices() {
        assert(ListChoicePreviews.standalone)
        assert(ListChoicePreviews.plain)
        assert(ListChoicePreviews.sizing)
        assert(ListChoicePreviews.storybook)
        assert(ListChoicePreviews.storybookButton)
        assert(ListChoicePreviews.storybookCheckbox)
        assert(ListChoicePreviews.storybookMix)
        assert(ListChoicePreviews.white)
        assert(ListChoicePreviews.backgroundColor)
    }
}

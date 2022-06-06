import XCTest
@testable import Orbit

class CardTests: SnapshotTestCase {

    func testCards() {
        assert(CardPreviews.standaloneIos)
        assert(CardPreviews.standalone)
        assert(CardPreviews.standaloneIntrinsic)
        assert(CardPreviews.storybook)
        assert(CardPreviews.borderless)
        assert(CardPreviews.borderlessRegular)
        assert(CardPreviews.borderlessRegularNarrow)
    }
}

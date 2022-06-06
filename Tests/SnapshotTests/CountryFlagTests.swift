import XCTest
@testable import Orbit

class CountryFlagTests: SnapshotTestCase {

    func testCountryFlags() {
        assert(CountryFlagPreviews.standalone)
        assert(CountryFlagPreviews.storybook)
    }
}

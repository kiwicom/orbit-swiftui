import XCTest
@testable import Orbit

class CountryFlagTests: SnapshotTestCase {

    func testCountryFlags() {
        assert(CountryFlagPreviews.snapshot)
    }
}

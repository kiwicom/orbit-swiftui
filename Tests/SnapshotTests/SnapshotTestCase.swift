import XCTest
import Orbit
import SwiftUI

class SnapshotTestCase: XCTestCase {

    override class func setUp() {
        super.setUp()
        Font.registerOrbitFonts()
        Font.fontSizeToHeightRatio = 1.2
    }
}

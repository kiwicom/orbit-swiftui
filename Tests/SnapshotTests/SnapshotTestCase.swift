import XCTest
import Orbit
import SwiftUI
import SnapshotTesting

class SnapshotTestCase: XCTestCase {

    override class func setUp() {
        super.setUp()
        Font.registerOrbitFonts()
        Font.registerOrbitIconFont()
    }
    
    override func invokeTest() {
        withSnapshotTesting(record: isForcedRecording ? .all : .never) {
            super.invokeTest()
        }
    }
}

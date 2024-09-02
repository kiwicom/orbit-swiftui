import UIKit
import XCTest
import SnapshotTesting
import SwiftUI

var isForcedRecording: Bool {
    #if XCODE_IS_SNAPSHOTS_RECORDING
    true
    #else
    false
    #endif
}

enum SnapshotSize {
    case intrinsic
    case deviceWidth
    case deviceSize
}

func assert<V: View>(
    _ snapshot: V,
    wait: TimeInterval = 0,
    size: SnapshotSize = .deviceWidth,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    var fixedVerticalSize: Bool {
        switch size {
            case .intrinsic:                            return true
            case .deviceWidth:                          return true
            case .deviceSize:                           return false
        }
    }

    let controller = UIHostingController(
        rootView: snapshot
            .fixedSize(
                horizontal: false,
                vertical: fixedVerticalSize
            )
            .environment(\.isFadeInEnabled, false)
    )

    switch size {
        case .intrinsic:        break
        case .deviceWidth:      controller.view.frame.size.width = UIScreen.main.bounds.width
        case .deviceSize:       controller.view.frame = UIScreen.main.bounds
    }

    guard let view = controller.view else {
        XCTFail("No view in ViewController")
        return
    }

    let imageSize = size == .intrinsic ? view.intrinsicContentSize : nil

    assertImage(
        matching: view,
        wait: wait,
        size: imageSize,
        file: file,
        testName: testName,
        line: line
    )
}

func assertImage(
    matching value: @autoclosure () throws -> UIView,
    wait: TimeInterval = 0.1,
    size: CGSize? = nil,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    if wait > 0 {
        assertSnapshotInCustomLocation(
            matching: try value(),
            as: .wait(for: wait, on: .image(size: size)),
            directory: snapshotTestsDirectoryPath(fromTestPath: file.description),
            file: file,
            testName: testName,
            line: line
        )
    } else {
        assertSnapshotInCustomLocation(
            matching: try value(),
            as: .image(size: size),
            directory: snapshotTestsDirectoryPath(fromTestPath: file.description),
            file: file,
            testName: testName,
            line: line
        )
    }
}

func assertImage(
    matching value: @autoclosure () throws -> UIViewController,
    wait: TimeInterval = 0,
    size: CGSize? = nil,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    if wait > 0 {
        assertSnapshotInCustomLocation(
            matching: try value(),
            as: .wait(for: wait, on: .image(size: size)),
            directory: snapshotTestsDirectoryPath(fromTestPath: file.description),
            file: file,
            testName: testName,
            line: line
        )
    } else {
        assertSnapshotInCustomLocation(
            matching: try value(),
            as: .image(size: size),
            directory: snapshotTestsDirectoryPath(fromTestPath: file.description),
            file: file,
            testName: testName,
            line: line
        )
    }
}

private func assertSnapshotInCustomLocation<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    directory: String,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    if FileManager.default.fileExists(atPath: directory) {
        do {
            try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)
        } catch {
            fatalError("Unable to create directory for snapshtos at \(directory)")
        }
    }

    let testFileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
    let finalDirectory = URL(fileURLWithPath: directory, isDirectory: true).appendingPathComponent(testFileName)

    let failure = verifySnapshot(
        of: try value(),
        as: snapshotting,
        named: name,
        record: isForcedRecording,
        snapshotDirectory: finalDirectory.path,
        timeout: timeout,
        file: file,
        testName: testName,
        line: line
    )

    guard let message = failure else { return }

    if isForcedRecording, message.contains("Automatically recorded snapshot") {
        return
    }

    XCTFail(message, file: file, line: line)
}

private func snapshotTestsDirectoryPath(fromTestPath filePath: String) -> String {

    func directoryContainsPackageFile(_ url: URL) -> Bool {
        let contents = try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

        return contents.contains(where: { $0.lastPathComponent == "Package.swift" })
    }

    var url = URL(fileURLWithPath: filePath).deletingLastPathComponent()

    while url.pathComponents.count > 1 {
        if directoryContainsPackageFile(url) {
            return url
                .appendingPathComponent("Snapshots")
                .appendingPathComponent(UIDevice.current.model)
                .path
        } else {
            url.deleteLastPathComponent()
        }
    }

    fatalError("Unable to find snapshots directory.")
}

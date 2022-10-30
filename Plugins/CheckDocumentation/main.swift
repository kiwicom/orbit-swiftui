import Foundation
import PackagePlugin

@main struct CheckDocumentation: CommandPlugin {

    func performCommand(context: PluginContext, arguments: [String]) async throws {
        for target in context.package.targets(ofType: SwiftSourceModuleTarget.self) where target.kind == .generic {
            try processTarget(target)
        }
    }

    func processTarget(_ target: SwiftSourceModuleTarget) throws {

        guard let doccBundle = Array(target.sourceFiles(withSuffix: "docc")).first else {
            Diagnostics.remark("No docc archive found for target \(target.name)")
            return
        }

        let markdownFilepaths = pathsToMarkdownFiles(in: doccBundle.path)

        // Symbols counted as "referenced" are either found in markdown files in the DocC bundle...
        let referencedSymbols = try Set(
            markdownFilepaths
                .map(symbolReferences(in:))
                .joined()
        )
        // ...or are the actual names of those markdown files.
        .union(markdownFilepaths.map(\.stem))

        let publicTypeNames = try Set(
            target.sourceFiles(withSuffix: "swift")
                .map(\.path)
                .map(publicTypeNames(in:))
                .joined()
        )

        let typesWithoutReference = publicTypeNames.subtracting(referencedSymbols)

        if typesWithoutReference.isEmpty == false {
            Diagnostics.error("Found types not referenced in DocC: \(typesWithoutReference.sorted().joined(separator: ", "))")
        }
    }

    func pathsToMarkdownFiles(in path: Path) -> [Path] {

        guard let doccEnumerator = FileManager.default.enumerator(atPath: path.string) else {
            Diagnostics.error("Unable to enumerate contents of docc at \(path).")
            return []
        }

        return doccEnumerator
            .compactMap { $0 as? String }
            .filter { $0.hasSuffix(".md") }
            .map { path.appending(subpath: $0) }
    }

    func symbolReferences(in path: Path) throws -> Set<String> {
        try regexCaptures("``(.*)``", in: path)
    }

    func publicTypeNames(in path: Path) throws -> Set<String> {
        try regexCaptures("^public (?:protocol|struct|enum|class|actor) ([A-z1-9]+)", in: path)
    }

    func regexCaptures(_ pattern: String, in path: Path) throws -> Set<String> {

        let text = try String(contentsOfFile: path.string)
        let unfortunatelyOldRegex = try NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)

        let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
        let captures = unfortunatelyOldRegex.matches(in: text, range: nsRange).map { result in
            let range = Range(result.range(at: 1), in: text)!
            return String(text[range])
        }

        return Set(captures)
    }
}

import UIKit
import SwiftUI

// Duplicate of TagAttributedStringBuilder in SharedUI with slight alterations.
@available(iOS, deprecated: 15.0, message: "Will be replaced with a native markdown-enabled Text component")
final class TagAttributedStringBuilder {

    enum Tag: Equatable, CaseIterable {
        case anchor
        case applink
        case bold
        case strong
        case underline
        case linebreak
        case ref
    }

    let tagFinder: TagAttributedStringBuilderTagFinder

    static var htmlAndAppLinks: TagAttributedStringBuilder {
        .init(tagFinder: TagAttributedStringBuilderTagFinder(tags: [.applink, .anchor]))
    }

    static var all: TagAttributedStringBuilder {
        .init(tagFinder: TagAttributedStringBuilderTagFinder(tags: Tag.allCases))
    }

    init(tagFinder: TagAttributedStringBuilderTagFinder) {
        self.tagFinder = tagFinder
    }

    func attributedString(
        _ string: String,
        textAttributes: [NSAttributedString.Key: Any],
        tagTextAttributes: [Tag: [NSAttributedString.Key: Any]]
    ) -> NSAttributedString {

        let attributedString = NSMutableAttributedString(string: string)

        attributedString.addAttributes(textAttributes, range: NSRange(location: 0, length: string.utf16.count))

        var results: [TagAttributedStringBuilderTagFinder.Result] = []

        repeat {
            results = tagFinder.innermostResults(for: attributedString.string)

            results.sorted(by: \.ranges[0].lowerBound).reversed().forEach { result in

                let tag = result.tag

                guard let tagAttributedString = tag.attributedString(
                    from: result,
                    currentAttributedString: NSAttributedString(attributedString: attributedString),
                    textAttributes: textAttributes,
                    tagTextAttributes: tagTextAttributes[tag] ?? [:]
                )
                else {
                    return
                }

                let nsRange = NSRange(result.ranges[0], in: result.input)
                attributedString.replaceCharacters(in: nsRange, with: tagAttributedString)
            }

        } while results.count > 0

        return attributedString
    }

    func attributedString(
        _ string: String,
        alignment: TextAlignment,
        fontSize: CGFloat,
        fontWeight: Font.Weight = .regular,
        lineSpacing: CGFloat?,
        kerning: CGFloat = 0,
        color: UIColor? = nil,
        linkColor: UIColor? = nil,
        accentColor: UIColor? = nil
    ) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .init(alignment)
        if let lineSpacing = lineSpacing {
            paragraphStyle.lineSpacing = lineSpacing
        }
        
        let adjustedKerning = kerning == 0
            ? 0.0001
            : kerning

        var textAttributes: [NSAttributedString.Key: Any] = [:]
        textAttributes[.font] = UIFont.orbit(size: fontSize, weight: fontWeight.uiKit)
        textAttributes[.kern] = adjustedKerning
        textAttributes[.foregroundColor] = color
        textAttributes[.paragraphStyle] = paragraphStyle

        var linksAttributes: [NSAttributedString.Key: Any] = [:]
        linksAttributes[.foregroundColor] = linkColor

        var refAttributes: [NSAttributedString.Key: Any] = [:]
        refAttributes[.foregroundColor] = accentColor

        return attributedString(
            string,
            textAttributes: textAttributes,
            tagTextAttributes: [
                .anchor: linksAttributes,
                .applink: linksAttributes,
                .ref: refAttributes,
            ]
        )
    }
}

struct TagAttributedStringBuilderTagFinder {

    struct Result: Equatable {
        let input: String
        let tag: TagAttributedStringBuilder.Tag
        let ranges: [Range<String.Index>]
    }

    let tags: [TagAttributedStringBuilder.Tag]

    func hasMatches(for input: String) -> Bool {

        let regularExpressions: [(TagAttributedStringBuilder.Tag, NSRegularExpression)] = tags.map { tag in
            do {
                return try (tag, NSRegularExpression(pattern: tag.pattern))
            } catch {
                fatalError("Invalid pattern")
            }
        }

        let matches = regularExpressions.flatMap { tag, expression in
            expression.matches(in: input, range: NSRange(location: 0, length: input.utf16.count)).map { (tag, $0) }
        }

        return matches.isEmpty == false
    }

    func innermostResults(for input: String) -> [Result] {

        let regularExpressions: [(TagAttributedStringBuilder.Tag, NSRegularExpression)] = tags.map { tag in
            do {
                return try (tag, NSRegularExpression(pattern: tag.pattern))
            } catch {
                fatalError("Invalid pattern")
            }
        }

        let matches = regularExpressions.flatMap { tag, expression in
            expression.matches(in: input, range: NSRange(location: 0, length: input.utf16.count)).map { (tag, $0) }
        }

        let results = matches.map { match in Result(input: input, tag: match.0, textCheckingResult: match.1) }
        let allRanges = results.map(\.ranges[0])

        return results.filter { result in allRanges.filter({ result.ranges[0].contains($0) }).count == 1 }
    }
}

public extension String {

    var containsHtmlFormatting: Bool {
        TagAttributedStringBuilder.all.tagFinder.hasMatches(for: self)
    }

    var containsTextLinks: Bool {
        TagAttributedStringBuilder.htmlAndAppLinks.tagFinder.hasMatches(for: self)
    }
}

private extension TagAttributedStringBuilder.Tag {

    var pattern: String {
        switch self {
            case .anchor:       return "<a.+?href=['|\"](.+?)['|\"].*?>(.+?)</a>"
            case .applink:      return "<(applink\\d+)>(.+?)</applink\\d+>"
            case .bold:         return "<b>(.+?)</b>"
            case .strong:       return "<strong>(.+?)</strong>"
            case .underline:    return "<u>(.+?)</u>"
            case .linebreak:    return "</?br/?>"
            case .ref:          return "<ref>(.+?)</ref>"
        }
    }

    func attributedString(
        from result: TagAttributedStringBuilderTagFinder.Result,
        currentAttributedString: NSAttributedString,
        textAttributes: [NSAttributedString.Key: Any],
        tagTextAttributes: [NSAttributedString.Key: Any]
    ) -> NSAttributedString? {

        switch self {
            case .anchor, .applink:
                guard result.ranges.count == 3,
                      let font = textAttributes[.font] as? UIFont
                else {
                    return nil
                }

                guard let url = URL(string: String(result.input[result.ranges[1]])) else { return nil }

                let attributes = [
                    .link: url,
                    .font: UIFont.orbit(size: font.pointSize, weight: .medium),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ].merging(tagTextAttributes, uniquingKeysWith: { $1 })

                return stringByAddingAttributes(attributes, to: currentAttributedString, at: result.ranges[2])
            case .bold, .strong:
                guard result.ranges.count == 2 else { return nil }

                let boldFont: UIFont

                if let font = tagTextAttributes[.font] as? UIFont {
                    boldFont = font
                } else if let font = textAttributes[.font] as? UIFont {
                    boldFont = .orbit(size: font.pointSize, weight: .bold)
                } else {
                    boldFont = .orbit(size: Text.Size.normal.value, weight: .bold)
                }

                return stringByAddingAttributes([.font: boldFont], to: currentAttributedString, at: result.ranges[1])

            case .underline:
                guard result.ranges.count == 2 else { return nil }

                return stringByAddingAttributes(
                    [.underlineStyle: NSUnderlineStyle.single.rawValue],
                    to: currentAttributedString,
                    at: result.ranges[1]
                )
            case .linebreak:
                return NSAttributedString(string: "\n", attributes: textAttributes)

            case .ref:
                guard result.ranges.count == 2,
                      let color = tagTextAttributes[.foregroundColor] as? UIColor,
                      let font = textAttributes[.font] as? UIFont
                else {
                    return nil
                }

                return stringByAddingAttributes(
                    [.foregroundColor: color, .font: UIFont.orbit(size: font.pointSize, weight: .bold)],
                    to: currentAttributedString,
                    at: result.ranges[1]
                )
        }
    }

    private func stringByAddingAttributes(
        _ attributes: [NSAttributedString.Key: Any],
        to currentAttributedString: NSAttributedString,
        at valueRange: Range<String.Index>
    ) -> NSAttributedString {

        let valueNSRange = NSRange(valueRange, in: currentAttributedString.string)
        let finalAttributedString = NSMutableAttributedString(
            attributedString: currentAttributedString.attributedSubstring(from: valueNSRange)
        )
        let finalStringRange = NSRange(location: 0, length: finalAttributedString.string.utf16.count)
        finalAttributedString.addAttributes(attributes, range: finalStringRange)

        return finalAttributedString
    }
}

private extension TagAttributedStringBuilderTagFinder.Result {

    init(input: String, tag: TagAttributedStringBuilder.Tag, textCheckingResult: NSTextCheckingResult) {
        self.input = input
        self.tag = tag

        ranges = (0..<textCheckingResult.numberOfRanges).compactMap { rangeIndex in
            Range(textCheckingResult.range(at: rangeIndex), in: input)
        }
    }
}

private extension Range {

    func contains(_ range: Range) -> Bool {
        lowerBound <= range.lowerBound && upperBound >= range.upperBound
    }
}

private extension Sequence {

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}

private extension NSTextAlignment {

    init(_ textAlignment: TextAlignment) {
        switch textAlignment {
            case .leading:      self = .left
            case .center:       self = .center
            case .trailing:     self = .right
        }
    }
}

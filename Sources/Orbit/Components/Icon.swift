import SwiftUI

/// An icon matching Orbit name.
///
/// - Related components:
///   - ``Illustration``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/icon/)
public struct Icon: View {

    public static let averagePadding: CGFloat = .xxxSmall
    
    let content: Content
    let size: Size

    public var body: some View {
        if content.isEmpty {
            EmptyView()
        } else {
            switch content {
                case .icon(let symbol, let color):
                    SwiftUI.Text(verbatim: symbol.value)
                        .foregroundColor(color)
                        .font(.orbitIcon(size: size.value))
                        .alignmentGuide(.firstTextBaseline) { dimensions in
                            size.textLineHeight * Text.firstBaselineRatio + dimensions.height / 2
                        }
                case .image(let image, let mode):
                    image
                        .resizable()
                        .aspectRatio(contentMode: mode)
                        .frame(width: size.value, height: size.value)
                        .alignmentGuide(.firstTextBaseline) { dimensions in
                            size.textLineHeight * Text.firstBaselineRatio + dimensions.height / 2
                        }
                case .countryFlag(let countryCode):
                    CountryFlag(countryCode, size: size)
                        .alignmentGuide(.firstTextBaseline) { dimensions in
                            size.textLineHeight * Text.firstBaselineRatio + dimensions.height / 2
                        }
                case .sfSymbol(let systemName):
                    Image(systemName: systemName)
                        .font(.system(size: size.value * 0.85))
                        .alignmentGuide(.firstTextBaseline) { dimensions in
                            size.textLineHeight * Text.firstBaselineRatio + dimensions.height / 2
                        }
                case .none:
                    EmptyView()
            }
        }
    }
}

// MARK: - Inits
public extension Icon {
    
    /// Creates Orbit Icon component for provided icon content.
    ///
    /// Color can be overriden using `foregroundColor` modifier when content color is set to `nil`.
    init(_ content: Icon.Content, size: Size = .normal) {
        self.content = content
        self.size = size
    }
    
    /// Creates Orbit Icon component for provided icon symbol.
    init(_ symbol: Icon.Symbol, size: Size = .normal, color: Color? = .inkNormal) {
        self.content = .icon(symbol, color: color)
        self.size = size
    }
    
    /// Creates Orbit Icon component for provided Image.
    init(image: Image, size: Size = .normal) {
        self.content = .image(image)
        self.size = size
    }
    
    /// Creates Orbit Icon component for provided country code.
    init(countryCode: String, size: Size = .normal) {
        self.content = .countryFlag(countryCode)
        self.size = size
    }
    
    /// Creates Orbit Icon component for provided SF Symbol.
    ///
    /// Color is configurable using `foregroundColor` modifier.
    init(sfSymbol: String, size: Size = .normal) {
        self.content = .sfSymbol(sfSymbol)
        self.size = size
    }
}

// MARK: - Types
public extension Icon {

    /// Defines content of an Icon for use in other components.
    ///
    /// Icon size is determined by enclosing component.
    enum Content: Equatable {
        case none
        /// Orbit icon symbol with overridable color.
        case icon(Symbol, color: Color? = nil)
        /// Icon using custom Image with overridable size.
        case image(Image, mode: ContentMode = .fit)
        /// Orbit CountryFlag.
        case countryFlag(String)
        /// SwiftUI SF Symbol with overridable color.
        case sfSymbol(String)
        
        public var isEmpty: Bool {
            switch self {
                case .none:                             return true
                case .icon(let symbol, _):              return symbol == .none
                case .image:                            return false
                case .countryFlag(let countryCode):     return countryCode.isEmpty
                case .sfSymbol(let sfSymbol):           return sfSymbol.isEmpty
            }
        }
    }

    enum Size: Equatable {
        /// Size 16.
        case small
        /// Size 20.
        case normal
        /// Size 24.
        case large
        /// Size 28.
        case xLarge
        /// Size based on Font size.
        case fontSize(CGFloat)
        /// Size based on `Text` size.
        case text(Text.Size)
        /// Size based on `Heading` style.
        case heading(Heading.Style)
        /// Size based on `Label` title style.
        case label(Label.Style)
        /// Custom size
        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
                case .small:                            return 16
                case .normal:                           return 20
                case .large:                            return 24
                case .xLarge:                           return 28
                case .fontSize(let size):               return size * 1.31
                case .text(let size):                   return size.iconSize
                case .heading(let style):               return style.iconSize
                case .label(let style):                 return style.iconSize
                case .custom(let size):                 return size
            }
        }
        
        public static func == (lhs: Icon.Size, rhs: Icon.Size) -> Bool {
            lhs.value == rhs.value
        }
        
        /// Default text line height for icon size.
        public var textLineHeight: CGFloat {
            switch self {
                case .small:                            return Text.Size.small.iconSize
                case .normal:                           return Text.Size.normal.iconSize
                case .large:                            return Text.Size.large.iconSize
                case .xLarge:                           return Text.Size.xLarge.iconSize
                case .fontSize(let size):               return size * 1.31
                case .text(let size):                   return size.iconSize
                case .heading(let style):               return style.iconSize
                case .label(let style):                 return style.iconSize
                case .custom(let size):                 return size
            }
        }
    }
}

// MARK: - Previews
struct IconPreviews: PreviewProvider {

    static let sfSymbol = "info.circle.fill"
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshotSizes
            snapshotSizesText
            snapshotSizesLabelText
            snapshotSizesHeading
            snapshotSizesLabelHeading
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Icon(.informationCircle)
    }
    
    static var storybook: some View {
        VStack(alignment: .leading, spacing: .medium) {
            snapshotSizes
            snapshotSizesText
            snapshotSizesHeading
        }
    }
    
    static var snapshotSizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            HStack(spacing: .xSmall) {
                Text("16", color: .custom(.redNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .small)
                    Text("Small text and icon size", size: .small)
                }
                .overlay(HairlineSeparator(), alignment: .top)
                .overlay(HairlineSeparator(), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("20", color: .custom(.orangeNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .normal)
                    Text("Normal text and icon size", size: .normal)
                }
                .overlay(HairlineSeparator(), alignment: .top)
                .overlay(HairlineSeparator(), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("24", color: .custom(.greenNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .large)
                    Text("Large text and icon size", size: .large)
                }
                .overlay(HairlineSeparator(), alignment: .top)
                .overlay(HairlineSeparator(), alignment: .bottom)
            }
        }
        .padding(.medium)
        .previewDisplayName("Default sizes")
    }
    
    static func headingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .heading(style))
                Heading("Heading", style: style)
            }
            .overlay(HairlineSeparator(), alignment: .top)
            .overlay(HairlineSeparator(), alignment: .bottom)
        }
    }
    
    static func labelHeadingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Heading", icon: .passengers, style: .heading(style))
                .overlay(HairlineSeparator(), alignment: .top)
                .overlay(HairlineSeparator(), alignment: .bottom)
        }
    }
    
    static func labelTextStack(_ size: Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Text", icon: .passengers, style: .text(size))
                .overlay(HairlineSeparator(), alignment: .top)
                .overlay(HairlineSeparator(), alignment: .bottom)
        }
    }
    
    static func textStack(_ size: Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .text(size))
                Text("Text", size: size)
            }
            .overlay(HairlineSeparator(), alignment: .top)
            .overlay(HairlineSeparator(), alignment: .bottom)
        }
    }
    
    static var snapshotSizesText: some View {
        VStack(alignment: .leading, spacing: .small) {
            textStack(.small)
            textStack(.normal)
            textStack(.large)
            textStack(.xLarge)
            textStack(.custom(50))
        }
        .padding(.medium)
        .previewDisplayName("Calculated sizes for Text")
    }
    
    static var snapshotSizesLabelText: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelTextStack(.small)
            labelTextStack(.normal)
            labelTextStack(.large)
            labelTextStack(.xLarge)
            labelTextStack(.custom(50))
        }
        .padding(.medium)
        .previewDisplayName("Calculated sizes for Text in Label")
    }
    
    static var snapshotSizesHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            headingStack(.title6)
            headingStack(.title5)
            headingStack(.title4)
            headingStack(.title3)
            headingStack(.title2)
            headingStack(.title1)
            headingStack(.displaySubtitle)
            headingStack(.display)
        }
        .padding(.medium)
        .previewDisplayName("Calculated sizes for Heading")
    }
    
    static var snapshotSizesLabelHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelHeadingStack(.title6)
            labelHeadingStack(.title5)
            labelHeadingStack(.title4)
            labelHeadingStack(.title3)
            labelHeadingStack(.title2)
            labelHeadingStack(.title1)
            labelHeadingStack(.displaySubtitle)
            labelHeadingStack(.display)
        }
        .padding(.medium)
        .previewDisplayName("Calculated sizes for Heading in Label")
    }

    static var storybookMix: some View {
        VStack(spacing: .small) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(.sfSymbol(sfSymbol), size: .custom(Text.Size.xLarge.iconSize))
                    Icon(.sfSymbol(sfSymbol), size: .fontSize(Text.Size.xLarge.value))
                    Icon(.sfSymbol(sfSymbol), size: .label(.text(.xLarge)))
                    Icon(.informationCircle, size: .custom(Text.Size.xLarge.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.xLarge.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.xLarge)), color: nil)
                    Text("XLarge", size: .xLarge, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(HairlineSeparator(), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(.sfSymbol(sfSymbol), size: .custom(Text.Size.small.iconSize))
                    Icon(.sfSymbol(sfSymbol), size: .fontSize(Text.Size.small.value))
                    Icon(.sfSymbol(sfSymbol), size: .label(.text(.small)))
                    Icon(.informationCircle, size: .custom(Text.Size.small.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.small.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.small)), color: nil)
                    Text("Small", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(HairlineSeparator(), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(.countryFlag("cz"), size: .xLarge)
                    Icon(.image(.orbit(.facebook)), size: .xLarge)
                    Icon(.sfSymbol(sfSymbol), size: .xLarge)
                    Text("Text", size: .custom(20), color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(HairlineSeparator(), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(.countryFlag("cz"), size: .small)
                    Icon(.image(.orbit(.facebook)), size: .small)
                    Icon(.sfSymbol(sfSymbol), size: .small)
                    Text("Text", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(HairlineSeparator(), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
            
            HStack(alignment: .firstTextBaseline) {
                Group {
                    Text("O", size: .custom(30))
                    Icon(.informationCircle, size: .fontSize(30))
                    Icon(.informationCircle, size: .fontSize(8))
                    Text("O", size: .custom(8))
                }
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(HairlineSeparator(), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
            
            HStack(alignment: .firstTextBaseline) {
                Icon(.grid, size: .xLarge, color: nil)
                Icon(.grid)
                Icon(.grid, size: .small, color: .red)
            }
            .foregroundColor(.blueDark)
            .background(HairlineSeparator(), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
        }
        .padding(.medium)
    }
}

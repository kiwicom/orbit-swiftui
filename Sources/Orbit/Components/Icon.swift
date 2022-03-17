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
                case .image(let image, let mode):
                    image
                        .resizable()
                        .aspectRatio(contentMode: mode)
                        .frame(width: size.value, height: size.value)
                case .countryFlag(let countryCode):
                    CountryFlag(countryCode, size: size)
                case .sfSymbol(let systemName):
                    Image(systemName: systemName)
                        .font(.system(size: size.value - 2 * Self.averagePadding))
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
        /// Size based on `Label` title style.
        case label(Label.TitleStyle)
        /// Custom size
        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
                case .small:                            return 16
                case .normal:                           return 20
                case .large:                            return 24
                case .xLarge:                           return 28
                case .fontSize(let size):               return size + 1
                case .label(let style):                 return style.iconSize
                case .custom(let size):                 return size
            }
        }
        
        public static func == (lhs: Icon.Size, rhs: Icon.Size) -> Bool {
            lhs.value == rhs.value
        }
    }
}

// MARK: - Previews
struct IconPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Icon(.informationCircle)
    }
    
    static var orbit: some View {
        snapshots
    }

    static var snapshots: some View {
        VStack(spacing: .small) {
            HStack {
                Icon(.flightNomad, size: .xLarge)
                Icon(.flightNomad)
                Icon(.flightNomad, size: .small)
            }
            
            HStack {
                Icon(.informationCircle, size: .xLarge, color: .inkLighter)
                Icon(.informationCircle, color: .inkLighter)
                Icon(.informationCircle, size: .small, color: .inkLighter)
            }
            
            HStack {
                Icon(.grid, size: .xLarge, color: nil)
                Icon(.grid)
                Icon(.grid, size: .small, color: .red)
            }
            .foregroundColor(.blueDark)
            
            Separator()
            
            HStack {
                Icon(image: .orbit(.facebook))
                Icon(countryCode: "cz", size: .large)
            }
            
            HStack(spacing: .xxSmall) {
                Icon(sfSymbol: "info.circle.fill", size: .normal)
                    .foregroundColor(.greenNormal)
                Icon(.informationCircle, size: .normal, color: nil)
                    .foregroundColor(.greenNormal)
                Icon(sfSymbol: "info.circle.fill", size: .xLarge)
                    .foregroundColor(.greenNormal)
                Icon(.informationCircle, size: .xLarge, color: nil)
                    .foregroundColor(.greenNormal)
            }
        }
        .frame(width: 120)
        .padding()
    }
}

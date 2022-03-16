import SwiftUI

/// An icon matching Orbit name.
///
/// - Related components:
///   - ``Illustration``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/icon/)
public struct Icon: View {

    public static let averagePadding: CGFloat = .xxxSmall
    let content: Icon.Content

    public var body: some View {
        if content.isEmpty {
            EmptyView()
        } else {
            switch content {
                case .icon(let symbol, let size, let color):
                    SwiftUI.Text(verbatim: symbol.value)
                        .foregroundColor(color)
                        .font(.orbitIcon(size: size.value))
                case .image(let image, let size, let mode):
                    image
                        .resizable()
                        .aspectRatio(contentMode: mode)
                        .frame(width: size.value, height: size.value)
                case .illustration(let illlustration, let size):
                    Illustration(illlustration, layout: .resizeable)
                        .frame(width: size.value, height: size.value)
                case .countryFlag(let countryCode, let size):
                    CountryFlag(countryCode, size: size)
                case .sfSymbol(let systemName, let size):
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
    init(_ content: Icon.Content) {
        self.content = content
    }
    
    /// Creates Orbit Icon component for provided icon symbol.
    init(_ symbol: Icon.Symbol, size: Size = .normal, color: Color? = .inkLighter) {
        self.init(.icon(symbol, size: size, color: color))
    }
}

// MARK: - Types
public extension Icon {

    /// Defines content of an Icon.
    enum Content: Equatable {
        case none
        /// Orbit icon symbol with size and optional overrideable color.
        case icon(Symbol, size: Size = .normal, color: Color? = nil)
        /// Icon using custom Image.
        case image(Image, size: Size = .normal, mode: ContentMode = .fit)
        /// Orbit illustration.
        case illustration(Illustration.Image, size: Size = .xLarge)
        /// Orbit CountryFlag.
        case countryFlag(String, size: Size = .normal)
        /// SwiftUI SF Symbol.
        case sfSymbol(String, size: Size = .normal)
        
        public var isEmpty: Bool {
            switch self {
                case .none:                             return true
                case .icon(let symbol, _, _):           return symbol == .none
                case .illustration(let image, _):       return image == .none
                case .image:                            return false
                case .countryFlag(let countryCode, _):  return countryCode.isEmpty
                case .sfSymbol(let systemName, _):      return systemName.isEmpty
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
        /// Size based on Header.Title style.
        case header(Label.TitleStyle)
        /// Custom size
        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
                case .small:                return 16
                case .normal:               return 20
                case .large:                return 24
                case .xLarge:               return 28
                case .fontSize(let size):   return size + 1
                case .header(let style):    return style.size + 1
                case .custom(let size):     return size
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
                Icon(.informationCircle, size: .xLarge, color: .inkNormal)
                Icon(.informationCircle, color: .inkNormal)
                Icon(.informationCircle, size: .small, color: .inkNormal)
            }

            HStack {
                Icon(.grid, size: .xLarge, color: nil)
                Icon(.grid)
                Icon(.grid, size: .small, color: .red)
            }
            .foregroundColor(.blueDark)
            
            Separator()
            
            HStack {
                Icon(.image(.orbit(.facebook)))
                Icon(.countryFlag("cz", size: .normal))
                Icon(.illustration(.womanWithPhone, size: .normal))
            }
            
            HStack(spacing: .xxSmall) {
                Icon(.sfSymbol("info.circle.fill", size: .normal))
                    .foregroundColor(.greenNormal)
                Icon(.informationCircle, size: .normal, color: nil)
                    .foregroundColor(.greenNormal)
                Icon(.sfSymbol("info.circle.fill", size: .xLarge))
                    .foregroundColor(.greenNormal)
                Icon(.informationCircle, size: .xLarge, color: nil)
                    .foregroundColor(.greenNormal)
            }
        }
        .frame(width: 120)
        .padding()
    }
}

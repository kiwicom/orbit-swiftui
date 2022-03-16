import SwiftUI

/// An icon matching Orbit name.
///
/// - Related components:
///   - ``Illustration``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/icon/)
public struct Icon: View {

    let content: Icon.Content

    public var body: some View {
        if content.isEmpty {
            EmptyView()
        } else {
            switch content {
                case .icon(let symbol, let size, let color):
                    SwiftUI.Text(verbatim: symbol.value)
                        .font(.orbitIcon(size: size.value))
                        .foregroundColor(color)
                case .image(let image, let size, let mode):
                    image
                        .resizable()
                        .aspectRatio(contentMode: mode)
                        .frame(width: size.value, height: size.value)
                case .illustration(let illlustration, let size):
                    Illustration(illlustration, layout: .resizeable)
                        .frame(width: size.value, height: size.value)
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
    init(_ symbol: Icon.Symbol, size: Size = .medium, color: Color? = .inkLighter) {
        self.init(.icon(symbol, size: size, color: color))
    }
}

// MARK: - Types
public extension Icon {

    /// Defines content of an Icon.
    enum Content: Equatable {
        case none
        /// Orbit icon symbol with size and optional overrideable color.
        case icon(Symbol, size: Size = .medium, color: Color? = nil)
        /// Icon using custom Image.
        case image(Image, size: Size = .medium, mode: ContentMode = .fit)
        /// Orbit illustration.
        case illustration(Illustration.Image, size: Size = .large)
        
        public var isEmpty: Bool {
            switch self {
                case .none:                             return true
                case .icon(let symbol, _, _):           return symbol == .none
                case .illustration(let image, _):       return image == .none
                case .image:                            return false
            }
        }
    }

    enum Size: Equatable {
        /// Size 16
        case small
        /// Size 20
        case `default`
        /// Size 24
        case medium
        /// Size 32
        case large
        /// Size based on Font size.
        case fontSize(CGFloat)
        /// Size based on Header.Title style.
        case header(Label.TitleStyle)
        /// Custom size
        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
                case .small:                return 16
                case .default:              return 20
                case .medium:               return 24
                case .large:                return 32
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

            ScrollView {
                orbit
                    .padding()
            }
        }
    }

    static var standalone: some View {
        Icon(.informationCircle)
            .previewLayout(.sizeThatFits)
    }

    static var orbit: some View {
        VStack(spacing: .small) {
            ForEach(Icon.Symbol.allCases.sorted(), id: \.self) { icon in
                HStack {
                    Text("\(icon)", size: .normal)
                        .layoutPriority(1)
                    Separator()
                    Icon(icon, size: .large, color: .inkNormal)
                    Icon(icon)
                    Icon(icon, size: .small, color: .inkLightActive)
                    Icon(icon, size: .small, color: nil)
                        .foregroundColor(.redNormal)
                }
            }
        }
        .previewDisplayName("Icons")
    }

    static var snapshots: some View {
        VStack(spacing: .small) {
            HStack {
                Icon(.flightNomad, size: .large)
                Icon(.flightNomad)
                Icon(.flightNomad, size: .small)
            }

            HStack {
                Icon(.informationCircle, size: .large, color: .inkNormal)
                Icon(.informationCircle, color: .inkNormal)
                Icon(.informationCircle, size: .small, color: .inkNormal)
            }

            HStack {
                Icon(.airplaneUp, size: .large, color: .blueDark)
                Icon(.airplaneUp, color: .blueDark)
                Icon(.airplaneUp, size: .small, color: .blueDark)
            }
        }
        .previewDisplayName("Icon sizes")
        .frame(width: 120)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

import SwiftUI

/// An icon matching Orbit name.
///
/// - Related components:
///   - ``Illustration``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/icon/)
public struct Icon: View {

    let symbol: Icon.Symbol
    let size: Size
    let color: Color?

    public var body: some View {
        if symbol == .none {
            EmptyView()
        } else {
            SwiftUI.Text(verbatim: symbol.value)
                .font(.orbitIcon(size: size.value))
                .foregroundColor(color)
        }
    }
}

// MARK: - Inits
public extension Icon {
    
    /// Creates Orbit Icon component for provided icon symbol.
    init(_ symbol: Icon.Symbol, size: Size = .medium, color: Color? = .inkLighter) {
        self.symbol = symbol
        self.size = size
        self.color = color
    }
}

// MARK: - Types
public extension Icon {

    /// Defines content of an Icon.
    enum Content: Equatable {
        case none
        /// Icon symbol with size and optional overrideable color.
        case icon(Symbol, size: Size = .medium, color: Color? = nil)
        /// Icon using custom Image.
        case image(Image, size: Size = .medium, mode: ContentMode = .fit)

        @ViewBuilder public func view(defaultColor: Color? = nil) -> some View {
            switch self {
                case .icon(let icon, let size, let color):
                    Icon(icon, size: size, color: color ?? defaultColor)
                case .image(let image, let size, let mode):
                    image
                        .resizable()
                        .aspectRatio(contentMode: mode)
                        .frame(width: size.value, height: size.value)
                case .none:
                    EmptyView()
            }
        }
        
        public var isEmpty: Bool {
            switch self {
                case .none:                     return true
                case .icon(let symbol, _, _):   return symbol == .none
                case .image:                    return false
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
        /// Custom size
        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
                case .small:                return 16
                case .default:              return 20
                case .medium:               return 24
                case .large:                return 32
                case .custom(let size):     return size
            }
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
                    Text(icon.rawValue, size: .normal)
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

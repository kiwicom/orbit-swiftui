import SwiftUI

public enum Layout {
    public static let preferredButtonHeight: CGFloat = 44
    public static let preferredSmallButtonHeight: CGFloat = .xLarge
    public static let iconSize = CGSize(width: 24, height: 24)
    public static let readableMaxWidth: CGFloat = 672
}

public extension Alignment {
    
    init(_ horizontalAlignment: HorizontalAlignment) {
        switch horizontalAlignment {
            case .leading:          self = .leading
            case .trailing:         self = .trailing
            default:                self = .center
        }
    }
}

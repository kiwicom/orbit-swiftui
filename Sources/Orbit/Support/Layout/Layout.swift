import SwiftUI

public enum Layout {
    /// Default maximum readable width used for layout in regular width environment.
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

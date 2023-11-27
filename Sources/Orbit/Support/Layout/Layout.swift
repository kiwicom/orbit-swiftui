import SwiftUI

public enum Layout {

    /// Maximum readable width used for Orbit layout in regular width environment.
    public static var readableMaxWidth: CGFloat = 672
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

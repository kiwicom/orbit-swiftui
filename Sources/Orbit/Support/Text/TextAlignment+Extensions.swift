import SwiftUI

extension TextAlignment {

    init(_ horizontalAlignment: HorizontalAlignment) {
        switch horizontalAlignment {
            case .leading:      self = .leading
            case .center:       self = .center
            case .trailing:     self = .trailing
            default:            self = .center
        }
    }
}

extension HorizontalAlignment {
    
    init(_ textAlignment: TextAlignment) {
        switch textAlignment {
            case .leading:      self = .leading
            case .center:       self = .center
            case .trailing:     self = .trailing
        }
    }
}

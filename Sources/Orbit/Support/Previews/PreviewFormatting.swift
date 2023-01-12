import Foundation

extension CGFloat {

    var formatted: String {
        abs(self.remainder(dividingBy: 1)) <= 0.001
            ? .init(format: "%.0f", self)
            : .init(format: "%.2f", self)
    }
}

extension Double {
    var formatted: String {
        CGFloat(self).formatted
    }
}

import CoreGraphics
import UIKit

public enum BorderWidth {
    /// 1 pixel border width.
    public static let hairline: CGFloat = 1.0 / UIScreen.main.scale
    /// 2/3 pts border width for default outline.
    public static let thin: CGFloat = UIScreen.main.scale > 2 ? 0.66 : 1
    /// 1.5 pts border width used for state emphasis.
    public static let emphasis: CGFloat = 1.5
    /// 2 pts border width used for actively selected component.
    public static let selection: CGFloat = 2.0
}

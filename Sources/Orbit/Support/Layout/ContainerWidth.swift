import CoreGraphics

public enum ContainerWidth {
    /// Expands horizontally up to `Layout.readableMaxWidth` by default.
    /// Ensures enough padding when the size closely matches ``Layout/readableMaxWidth`` in regular size environment.
    case expanding(upTo: CGFloat = Layout.readableMaxWidth, minimalRegularWidthPadding: CGFloat = .medium)
    case intrinsic
}

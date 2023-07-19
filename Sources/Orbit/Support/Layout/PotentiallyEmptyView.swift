
/// A type that represents views that can optionally result in `EmptyView`.
protocol PotentiallyEmptyView {
    var isEmpty: Bool { get }
}

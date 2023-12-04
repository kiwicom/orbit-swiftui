
/// A type that represents Orbit components that can optionally result in `EmptyView`.
protocol PotentiallyEmptyView {
    var isEmpty: Bool { get }
}

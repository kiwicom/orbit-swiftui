import SwiftUI

public protocol TagModel: Identifiable, Equatable {
    var label: String { get }
    var icon: Icon.Content { get }
    var accessibilityIdentifier: String { get }
    var isRemovable: Bool { get }
    var isFocused: Bool { get }
    var isRemoved: Bool { get set }
    var isSelected: Bool { get set }
}

public extension TagModel {
    var accessibilityIdentifier: String { "" }
    var icon: Icon.Content { .none }
    var isFocused: Bool { isSelected }
}

/// Collection of Orbit tags with binding through `TagModel` protocol.
///
/// Can be used in single line or multiline layout.
public struct TagGroup<TM: TagModel>: View {

    @Environment(\.accessibilityReduceMotion) private var isReduceMotionEnabled
    @Environment(\.isFadeIn) private var isFadeIn
    @State private var tagsFadeIn: [Bool] = []
    @Binding private var tags: [TM]

    private let spacing: UIOffset
    private let label: String
    private let showRemovedTags: Bool
    private let layout: Layout

    public var body: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            if label.isEmpty == false {
                FieldLabel(label)
            }

            switch layout {
                case .singleLineScrollable:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing.horizontal) {
                            ForEach(tags) { tagView(for: $0) }
                        }
                    }
                    .accessibilityElement(children: .contain)
                case .multiLine:
                    CollectionView(data: tags, spacing: spacing) { index in
                        tagView(for: tags[index])
                    }
                    .accessibilityElement(children: .contain)
            }
        }
        .onAppear {
            if isFadeIn, isReduceMotionEnabled == false {
                tagsFadeIn = tags.map { _ in false }
                let delays = tags.enumerated().map { Double($0.offset) * 0.15 }.shuffled()

                for index in 0..<tags.count {
                    withAnimation(.spring(response: 0.74, dampingFraction: 0.5).delay(delays[index])) {
                        tagsFadeIn[index] = true
                    }
                }
            }
        }
    }

    /// Creates a collection of related Orbit Tag components.
    public init(
        label: String = "",
        tags: Binding<[TM]>,
        showRemovedTags: Bool = false,
        layout: Layout,
        spacing: UIOffset = UIOffset(horizontal: .xSmall, vertical: .xSmall)
    ) {
        self.label = label
        _tags = tags
        self.showRemovedTags = showRemovedTags
        self.layout = layout
        self.spacing = spacing
    }
    
    @ViewBuilder private func tagView(for tag: TM) -> some View {
        if let index = tags.firstIndex(of: tag), showRemovedTags || tag.isRemoved == false {
            Tag(
                tag.label,
                icon: tags[index].icon,
                style: tag.isRemovable ? .removable(action: { tags[index].isRemoved = true }) : .default,
                isFocused: tags[index].isFocused,
                isSelected: $tags[index].isSelected.wrappedValue
            ) {
                $tags[index].isSelected.wrappedValue.toggle()
            }
            .accessibility(identifier: tag.accessibilityIdentifier)
            .opacity(isFadeIn(forIndex: index) ? 1 : 0)
            .scaleEffect(isFadeIn(forIndex: index) ? 1 : 0.3)
        }
    }

    private func isFadeIn(forIndex index: Int) -> Bool {
        guard index >= 0, index < tagsFadeIn.endIndex else {
            return true
        }

        return tagsFadeIn[index]
    }
}

// MARK: - Types
public extension TagGroup {

    enum Layout {
        /// Tags are laid out on a single line in a horizontal scroll view.
        case singleLineScrollable
        /// Tags are laid out in an available space, wrapping the tags on next line if needed.
        case multiLine
    }
}

// MARK: - Previews
struct TagGroupPreviews: PreviewProvider {

    struct TagModelPreview: TagModel {
        let id: Int
        let label: String
        var icon: Icon.Content = .none
        var isRemovable = false
        var isRemoved = false
        var isSelected = false
    }

    static var previews: some View {
        PreviewWrapper {
            snapshots
            live
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static let snapshotTags = [
        TagModelPreview(id: 0, label: "Sorting", icon: .sort, isRemovable: true, isSelected: true),
        TagModelPreview(id: 1, label: "Pricing", icon: .money, isRemovable: true),
        TagModelPreview(id: 2, label: "Vienna", isRemovable: true, isSelected: true),
        TagModelPreview(id: 3, label: "Paris", isRemovable: false),
        TagModelPreview(id: 4, label: "Milan", isRemovable: false),
        TagModelPreview(id: 5, label: "New York", isRemovable: false),
        TagModelPreview(id: 6, label: "Delhi", isRemovable: true),
        TagModelPreview(id: 7, label: "Sutton-under-Whitestonecliffe", isRemovable: true),
        TagModelPreview(id: 8, label: "Hongkong", isRemovable: true),
        TagModelPreview(id: 9, label: "Chaussée-Notre-Dame-Louvignies", isRemovable: true),
    ]

    static var snapshots: some View {
        Group {
            TagGroup(tags: .constant(snapshotTags), layout: .singleLineScrollable)
                .previewDisplayName("Single line scrollable")

            TagGroup(tags: .constant(snapshotTags), layout: .multiLine)
                .frame(height: 200)
                .previewDisplayName("Multi line")
        }
    }

    static var live: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .xxSmall) {
                StateWrapper(
                    initialState: [
                        TagModelPreview(id: 1, label: "One"),
                        TagModelPreview(id: 2, label: "Two", isSelected: true),
                    ]
                ) { tags in
                    TagGroup(tags: tags, layout: .singleLineScrollable)
                        .environment(\.isFadeIn, true)
                }

                Separator()

                StateWrapper(
                    initialState: [
                        TagModelPreview(id: 1, label: "Bags", isRemovable: true, isSelected: false),
                        TagModelPreview(id: 2, label: "Price", isRemovable: false, isSelected: true),
                        TagModelPreview(id: 3, label: "Days", isRemovable: false, isSelected: false),
                        TagModelPreview(id: 4, label: "Carriers", isRemovable: true, isSelected: true),
                        TagModelPreview(id: 5, label: "Countries", isRemovable: true, isSelected: false),
                    ]
                ) { tags in
                    VStack(alignment: .leading) {
                        TagGroup(label: "Filters", tags: tags, showRemovedTags: true, layout: .singleLineScrollable)
                            .environment(\.isFadeIn, true)

                        ForEach(tags.wrappedValue) { tag in
                            HStack {
                                Icon(tag.isSelected ? .checkCircle : .circleEmpty, size: .small)
                                Icon(tag.isRemoved ? .remove : .circleEmpty, size: .small)
                                Text(tag.label, size: .small)
                            }
                        }
                    }
                }

                Separator()

                StateWrapper(
                    initialState: [
                        TagModelPreview(id: 1, label: "Fun 🎢", isRemovable: false, isSelected: false),
                        TagModelPreview(id: 2, label: "Adventure 🏕", isRemovable: false, isSelected: true),
                        TagModelPreview(id: 3, label: "Music 🎷", isRemovable: false, isSelected: false),
                        TagModelPreview(id: 4, label: "Sport ⚽️", isRemovable: false, isSelected: true),
                        TagModelPreview(id: 5, label: "Nightlife 🍻", isRemovable: false, isSelected: false),
                        TagModelPreview(id: 6, label: "Beach 🏖", isRemovable: false, isSelected: false),
                    ]
                ) { tags in
                    TagGroup(label: "Interests", tags: tags, layout: .multiLine)
                }

                Separator()

                StateWrapper(
                    initialState: [
                        TagModelPreview(id: 1, label: "Prague", isRemovable: true),
                        TagModelPreview(id: 2, label: "Vienna", isRemovable: true, isSelected: true),
                        TagModelPreview(id: 3, label: "Paris", isRemovable: true),
                        TagModelPreview(id: 4, label: "Milan", isRemovable: true),
                        TagModelPreview(id: 5, label: "New York", isRemovable: true),
                        TagModelPreview(id: 6, label: "Delhi", isRemovable: true),
                        TagModelPreview(id: 7, label: "Sutton-under-Whitestonecliffe", isRemovable: true),
                        TagModelPreview(id: 8, label: "Hongkong", isRemovable: true),
                        TagModelPreview(id: 9, label: "Chaussée-Notre-Dame-Louvignies", isRemovable: true),
                    ]
                ) { tags in
                    TagGroup(label: "Removable tags", tags: tags, layout: .multiLine)
                        .environment(\.isFadeIn, true)
                }
            }
        }
        .previewDisplayName("Live Preview")
    }
}

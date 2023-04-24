import SwiftUI

/// Showing two choices from which only one can be selected.
///
/// Currently SegmentedSwitch allows to have 2 segments.
/// SegmentedSwitch can be in error state only in unselected state.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/segmentedswitch/)
public struct SegmentedSwitch: View {

    let verticalTextPadding: CGFloat = .small // = 44 @ normal text size

    @Environment(\.colorScheme) private var colorScheme

    @Binding private var selectedIndex: Int?
    let label: String
    let message: Message?
    let firstOption: String
    let secondOption: String

    let borderWidth: CGFloat = BorderWidth.active

    public var body: some View {
        FieldWrapper(label, message: message) {
            InputContent(message: message) {
                HStack(spacing: 0) {
                    segment(title: firstOption)
                        .accessibility(.segmentedSwitchFirstOption)

                    separator

                    segment(title: secondOption)
                        .accessibility(.segmentedSwitchSecondOption)
                }
                .background(selectionBackground)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(selection?.description ?? ""))
        .accessibility(hint: .init(accessibilityHint))
        .accessibility(addTraits: .isButton)
        .accessibility(addTraits: selection != nil ? .isSelected : [])
    }

    @ViewBuilder func segment(title: String) -> some View {
        Text(title)
            .multilineTextAlignment(.center)
            .padding(.horizontal, .xSmall)
            .padding(.vertical, verticalTextPadding)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedIndex = title == firstOption ? 0 : 1
            }
    }

    @ViewBuilder var separator: some View {
        separatorColor
          .frame(width: borderWidth)
          .frame(maxHeight: .infinity)
          .padding(.vertical, BorderWidth.active)
    }

    @ViewBuilder var selectionBackground: some View {
        HStack(spacing: 0) {
            if selection == secondOption {
                Spacer(minLength: 0)
                    .layoutPriority(1)
            }

            (colorScheme == .light ? Color.whiteDarker : Color.cloudDarkActive)
                .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
                .padding(borderWidth)
                .elevation(selection != nil ? .level1 : nil)
                .layoutPriority(1)

            if selection == firstOption {
                Spacer(minLength: 0)
                    .layoutPriority(1)
            }
        }
        .animation(.easeOut(duration: 0.2), value: selectedIndex)
    }

    private var selection: String? {
        if selectedIndex == 0 {
            return firstOption
        } else if selectedIndex == 1 {
            return secondOption
        } else {
            return nil
        }
    }

    private var separatorColor: Color {
        selection == nil ? borderColor : .clear
    }

    private var borderColor: Color {
        message?.status?.color ?? .cloudNormal
    }

    private var accessibilityHint: String {
        "\(message?.description.appending(":") ?? "") \(firstOption)\\\(secondOption)"
    }
    
    public init(
        _ label: String = "",
        firstOption: String,
        secondOption: String,
        selectedIndex: Binding<Int?>,
        message: Message? = nil
    ) {
        self.label = label
        self.firstOption = firstOption
        self.secondOption = secondOption
        self._selectedIndex = selectedIndex
        self.message = message
    }
}

public extension AccessibilityID {
    static let segmentedSwitchFirstOption = Self(rawValue: "orbit.segmentedswitch.first")
    static let segmentedSwitchSecondOption = Self(rawValue: "orbit.segmentedswitch.second")
}

// MARK: - Previews
struct SegmentedSwitchPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            unselected
            sizing
            selected
            help
            error
            interactive
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var unselected: some View {
        segmentedSwitch()
            .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            segmentedSwitch(selectedIndex: nil, label: "")
                .measured()
            segmentedSwitch(selectedIndex: 1, label: "")
                .measured()
            segmentedSwitch(selectedIndex: 1, secondOption: "Multiline\nOption", label: "")
                .measured()
        }
        .previewDisplayName()
    }

    static var selected: some View {
        segmentedSwitch(selectedIndex: 0)
            .previewDisplayName()
    }

    static var help: some View {
        segmentedSwitch(message: .help("Help message"))
            .previewDisplayName()
    }

    static var error: some View {
        segmentedSwitch(message: .error("Error message"))
            .previewDisplayName()
    }

    static var interactive: some View {
        StateWrapper(Int?(2)) { value in
            VStack(spacing: .large) {
                SegmentedSwitch(
                    "Gender\nmultiline",
                    firstOption: "Male with long name",
                    secondOption: "Female with much longer name",
                    selectedIndex: value
                )
                Text(value.wrappedValue?.description ?? "")
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(spacing: .xMedium) {
            unselected
            selected
            help
            error
        }
        .padding(.medium)
    }

    static func segmentedSwitch(
        selectedIndex: Int? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        label: String = "Gender",
        message: Message? = nil
    ) -> some View {
        StateWrapper(selectedIndex) { value in
            SegmentedSwitch(
                label,
                firstOption: firstOption,
                secondOption: secondOption,
                selectedIndex: value,
                message: message
            )
        }
    }
}

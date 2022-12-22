import SwiftUI

/// Showing two choices from which only one can be selected.
///
/// Currently SegmentedSwitch allows to have 2 segments.
/// SegmentedSwitch can be in error state only in unselected state.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/segmentedswitch/)
public struct SegmentedSwitch<Value>: View where Value: LosslessStringConvertible & Equatable {

    @Binding private var selection: Value?
    let label: String
    let _message: Message?
    let firstOption: Value
    let secondOption: Value

    let separatorWidth: CGFloat = BorderWidth.emphasis
    let borderWidth: CGFloat = BorderWidth.emphasis

    public var body: some View {
        FieldWrapper(
            label,
            message: message
        ) {
            HStack(spacing: 0) {
                segment(title: firstOption)
                    .accessibility(.segmentedSwitchFirstOption)
                separator
                segment(title: secondOption)
                    .accessibility(.segmentedSwitchSecondOption)
            }
            .background(selectionBackground)
            .background(roundedBackground)
            .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(selection?.description ?? ""))
        .accessibility(hint: .init(accessibilityHint))
        .accessibility(addTraits: .isButton)
        .accessibility(addTraits: selection != nil ? .isSelected : [])
    }

    @ViewBuilder func segment(title: Value) -> some View {
        Text(title.description)
            .padding( .xSmall)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                selection = title
            }
    }

    @ViewBuilder var separator: some View {
        borderColor
          .frame(width: separatorWidth)
    }

    @ViewBuilder var selectionBackground: some View {
        HStack {
            if selection == secondOption {
                Spacer(minLength: 0)
                    .layoutPriority(1)
            }

            Color.whiteDarker
                .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default - 1))
                .padding(borderWidth)
                .elevation(selection != nil ? .level1 : nil)
                .layoutPriority(1)

            if selection == firstOption {
                Spacer(minLength: 0)
                    .layoutPriority(1)
            }
        }
        .animation(.easeOut(duration: 0.2), value: selection)
    }

    @ViewBuilder var roundedBackground: some View {
        RoundedRectangle(cornerRadius: BorderRadius.default)
            .fill(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }

    private var message: Message? {
        switch (_message, selection) {
            case (.error, .some):   return nil
            default:                return _message
        }
    }

    private var backgroundColor: Color {
        selection != nil ? .cloudNormal : .whiteDarker
    }

    private var borderColor: Color {
        guard selection == nil else { return .clear }

        switch message {
            case .error:    return .redNormal
            default:        return .cloudNormal
        }
    }

    private var accessibilityHint: String {
        "\(message?.description.appending(":") ?? "") \(firstOption)\\\(secondOption)"
    }
    
    public init(
        label: String,
        firstOption: Value,
        secondOption: Value,
        selection: Binding<Value?>,
        message: Message? = nil
    ) {
        self.label = label
        self.firstOption = firstOption
        self.secondOption = secondOption
        self._selection = selection
        self._message = message
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

    static var selected: some View {
        segmentedSwitch(selection: "Male")
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
        StateWrapper<String?, _>(initialState: nil) { value in
            VStack(spacing: .large) {
                SegmentedSwitch(
                    label: "Gender\nmultiline",
                    firstOption: "Male with long name",
                    secondOption: "Female with much longer name",
                    selection: value
                )
                Text(value.wrappedValue ?? "")
            }
        }
        .previewDisplayName("Live Preview")
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
        selection: String? = nil,
        firstOption: String = "Male",
        secondOption: String = "Female",
        label: String = "Gender",
        message: Message? = nil
    ) -> some View {
        StateWrapper(initialState: selection) { value in
            SegmentedSwitch(
                label: label,
                firstOption: firstOption,
                secondOption: secondOption,
                selection: value,
                message: message
            )
        }
    }
}

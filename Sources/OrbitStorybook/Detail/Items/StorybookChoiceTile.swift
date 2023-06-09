import SwiftUI
import Orbit

struct StorybookChoiceTile {

    static let title = "ChoiceTile title"
    static let description = "Additional information for this choice."

    static var basic: some View {
        VStack(spacing: .medium) {
            choiceTileContent
        }
        .previewDisplayName()
    }

    static var centered: some View {
        VStack(spacing: .medium) {
            choiceTileContentCentered
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .medium) {
            StateWrapper(false) { isSelected in
                ChoiceTile(
                    "Checkbox indictor with long and multiline title",
                    icon: .symbol(.grid, color: .greenNormal),
                    indicator: .checkbox,
                    isSelected: isSelected.wrappedValue,
                    message: .help("Info multiline and very very very very long message")
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    contentPlaceholder
                }
            }
            StateWrapper(false) { isSelected in
                ChoiceTile(
                    description: "Long and multiline description with no title",
                    icon: .transparent,
                    isSelected: isSelected.wrappedValue,
                    message: .warning("Warning multiline and very very very very long message")
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    contentPlaceholder
                }
            }
            StateWrapper(false) { isSelected in
                ChoiceTile(
                    isSelected: isSelected.wrappedValue
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    Color.greenLight
                        .overlay(Text("Custom content, no header"))
                }
            }
        }
        .previewDisplayName()
    }

    @ViewBuilder static var choiceTileContent: some View {
        choiceTile(titleStyle: .title4, showHeader: true, isError: false, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: true, isError: false, isSelected: true)
        choiceTile(titleStyle: .title3, showHeader: true, isError: false, isSelected: false)
        choiceTile(titleStyle: .title3, showHeader: true, isError: false, isSelected: true)
        choiceTile(titleStyle: .title4, showHeader: false, isError: false, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: false, isError: false, isSelected: true)
        choiceTile(titleStyle: .title4, showHeader: true, isError: true, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: true, isError: true, isSelected: true)
    }

    @ViewBuilder static var choiceTileContentCentered: some View {
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: false, isSelected: false)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: false, isSelected: true)
        choiceTileCentered(titleStyle: .title3, showIllustration: true, isError: false, isSelected: false)
        choiceTileCentered(titleStyle: .title3, showIllustration: true, isError: false, isSelected: true)
        choiceTileCentered(titleStyle: .title3, showIllustration: false, isError: false, isSelected: false)
        choiceTileCentered(titleStyle: .title3, showIllustration: false, isError: false, isSelected: true)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: true, isSelected: false)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: true, isSelected: true)
    }

    static func choiceTile(titleStyle: Heading.Style, showHeader: Bool, isError: Bool, isSelected: Bool) -> some View {
        StateWrapper(isSelected) { state in
            ChoiceTile(
                showHeader ? title : "",
                description: showHeader ? description : "",
                icon: showHeader ? .grid : .none,
                titleStyle: titleStyle,
                isSelected: state.wrappedValue,
                isError: isError
            ) {
                state.wrappedValue.toggle()
            } content: {
                contentPlaceholder
            }
        }
    }

    static func choiceTileCentered(titleStyle: Heading.Style, showIllustration: Bool, isError: Bool, isSelected: Bool) -> some View {
        StateWrapper(isSelected) { state in
            ChoiceTile(
                title,
                description: description,
                icon: showIllustration ? .none : .grid,
                illustration: showIllustration ? .priorityBoarding : .none,
                badgeOverlay: "Recommended",
                titleStyle: titleStyle,
                isSelected: state.wrappedValue,
                isError: isError,
                alignment: .center
            ) {
                state.wrappedValue.toggle()
            } content: {
                contentPlaceholder
            }
        }
    }
}

struct StorybookChoiceTilePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookChoiceTile.basic
            StorybookChoiceTile.centered
            StorybookChoiceTile.mix
        }
    }
}

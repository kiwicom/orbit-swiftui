import SwiftUI
import Orbit

public extension ChoiceTile {

    /// Creates Orbit ChoiceTile component.
    ///
    /// - Parameters:
    ///   - content: The content shown below the header.
    ///   - header: A trailing view placed inside the tile header.
    init(
        _ title: String = "",
        description: String = "",
        illustration: OrbitIllustrations.Illustration.Asset,
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: Message? = nil,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder header: () -> Header = { EmptyView() }
    ) where Illustration == OrbitIllustrations.Illustration {
        self.init(
            title,
            description: description,
            badgeOverlay: badgeOverlay,
            indicator: indicator,
            titleStyle: titleStyle,
            isSelected: isSelected,
            isError: isError,
            message: message,
            alignment: alignment,
            action: action,
            content: content,
            icon: icon,
            header: header
        ) {
            Illustration(illustration, layout: .resizeable)
        }
    }

    /// Creates Orbit ChoiceTile component.
    ///
    /// - Parameters:
    ///   - content: The content shown below the header.
    ///   - header: A trailing view placed inside the tile header.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        illustration: OrbitIllustrations.Illustration.Asset,
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: Message? = nil,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder header: () -> Header = { EmptyView() }
    ) where Icon == Orbit.Icon, Illustration == OrbitIllustrations.Illustration {
        self.init(
            title,
            description: description,
            badgeOverlay: badgeOverlay,
            indicator: indicator,
            titleStyle: titleStyle,
            isSelected: isSelected,
            isError: isError,
            message: message,
            alignment: alignment,
            action: action,
            content: content,
            icon: {
                Icon(icon)
            },
            header: header
        ) {
            Illustration(illustration, layout: .resizeable)
        }
    }
}

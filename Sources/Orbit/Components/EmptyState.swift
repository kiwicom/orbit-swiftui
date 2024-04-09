import SwiftUI

/// Orbit component that indicates there is no data to display. 
/// A counterpart of the native `SwiftUI.ContentUnavailableView`.
///
/// An ``EmptyState`` consists of a title, description, icon, optional custom content and at most two actions.
///
/// ```swift
/// EmptyState("No travelers") {
///     Button("Add new traveler") { /* Tap action */ }
/// }
/// ```
/// 
/// ### Customizing appearance
///
/// The title color can be modified by ``textColor(_:)`` modifier.
///
/// A ``Status`` of buttons can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// EmptyState("No data") {
///     Button("Add item") { /* Tap action */ }
/// }
/// .status(.warning)
/// ```
///
/// The default button priority can be overridden by ``buttonPriority(_:)`` modifier:
///
/// ```swift
/// EmptyState("No data") {
///     Button("Secondary Only") {
///         // Tap action 
///     }
///     .buttonPriority(.secondary)
/// }
/// ```
/// 
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/progress-indicators/emptystate/)
public struct EmptyState<Title: View, Description: View, Buttons: View, Illustration: View>: View {

    @ViewBuilder private let title: Title
    @ViewBuilder private let description: Description
    @ViewBuilder private let buttons: Buttons
    @ViewBuilder private let illustration: Illustration

    public var body: some View {
        VStack(spacing: .medium) {
            if illustration.isEmpty == false {
                illustration
                    .padding(.top, .large)
            }
        
            texts

            if buttons.isEmpty == false {
                VStack(spacing: .xSmall) {
                    buttons
                }
                .textColor(nil)
            }
        }
        .frame(maxWidth: Layout.readableMaxWidth * 2/3)
        .padding(.medium)
        .accessibilityElement(children: .contain)
        .accessibility(.emptyState)
    }
    
    @ViewBuilder var texts: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(spacing: .xxSmall) {
                title
                    .accessibility(.emptyStateTitle)
                
                description
                    .textColor(.inkNormal)
                    .accessibility(.emptyStateDescription)
            }
            .multilineTextAlignment(.center)
        }
    }
    
    /// Creates Orbit ``EmptyState`` component with custom content.
    public init(
        @ButtonStackBuilder buttons: () -> Buttons,
        @ViewBuilder title: () -> Title = { EmptyView() },
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.title = title()
        self.description = description()
        self.buttons = buttons()
        self.illustration = illustration()
    }
}

// MARK: - Convenience Inits
public extension EmptyState where Title == Heading, Description == Text {
    
    /// Creates Orbit ``EmptyState`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        @ButtonStackBuilder buttons: () -> Buttons = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.init(buttons: buttons) {
            Heading(title, style: .title3)
        } description: {
            Text(description)
        } illustration: {
            illustration()
        }
    }
    
    /// Creates Orbit ``EmptyState`` component with localizable texts.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        tableName: String? = nil,
        bundle: Bundle? = nil,
        titleComment: StaticString? = nil,
        @ButtonStackBuilder buttons: () -> Buttons = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.init(buttons: buttons) {
            Heading(title, style: .title3, tableName: tableName, bundle: bundle)
        } description: {
            Text(description, tableName: tableName, bundle: bundle)
        } illustration: {
            illustration()
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let emptyState               = Self(rawValue: "orbit.emptystate")
    static let emptyStateTitle          = Self(rawValue: "orbit.emptystate.title")
    static let emptyStateDescription    = Self(rawValue: "orbit.emptystate.description")
}

// MARK: - Previews
struct EmptyStatePreviews: PreviewProvider {

    static let title = "No results"
    static let description = "Try a quick search to explore hundreds of affordable options."
    static let primaryButton = "Primary action"
    static let secondaryButton = "Secondary action"

    static var previews: some View {
        PreviewWrapper {
            standalone
            override
            noAction
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        EmptyState(title, description: description) {
            Button(primaryButton) {}
            Button(secondaryButton) {}
        } illustration: {
            illustrationPlaceholder
        }
        .previewDisplayName()
    }
    
    static var override: some View {
        EmptyState(title, description: description) {
            Button(primaryButton) {}
            Button(primaryButton) {}
                .buttonPriority(.primary)
                .status(.info)
        } illustration: {
            illustrationPlaceholder
        }
        .status(.critical)
        .previewDisplayName()
    }
    
    static var noAction: some View {
        EmptyState(title, description: description) {
            contentPlaceholder
        } illustration: {
            illustrationPlaceholder
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
    }
}

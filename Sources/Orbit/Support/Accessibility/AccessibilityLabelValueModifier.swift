import SwiftUI

struct AccessibilityLabelValueModifier<Label: View, Value: View, Hint: View>: ViewModifier {
    
    @Environment(\.localizationBundle) private var localizationBundle
    @Environment(\.locale) private var locale
    
    let childBehavior: AccessibilityChildBehavior?
    @ViewBuilder let label: Label
    @ViewBuilder let value: Value
    @ViewBuilder let hint: Hint
    
    func body(content: Content) -> some View {
        if isLabelTextual {
            if let childBehavior {
                content
                    .accessibilityElement(children: childBehavior)
                    .accessibility(label: textualLabel ?? SwiftUI.Text(""))
                    .accessibility(value: textualValue ?? SwiftUI.Text(""))
                    .accessibility(hint: textualHint ?? SwiftUI.Text(""))

            } else {
                content
                    .accessibility(label: textualLabel ?? SwiftUI.Text(""))
                    .accessibility(value: textualValue ?? SwiftUI.Text(""))
                    .accessibility(hint: textualHint ?? SwiftUI.Text(""))
            }
        } else {
            content
                .accessibilityElement(children: .contain)
        }
    }
    
    private var isLabelTextual: Bool {
        textualLabel != nil
    }
    
    private var textualLabel: SwiftUI.Text? {
        label.text(locale: locale, localizationBundle: localizationBundle)
    }
    
    private var textualValue: SwiftUI.Text? {
        value.text(locale: locale, localizationBundle: localizationBundle)
    }
    
    private var textualHint: SwiftUI.Text? {
        hint.text(locale: locale, localizationBundle: localizationBundle)
    }
}

extension View {
    
    func accessibility<Label: View, Value: View, Hint: View>(
        children: AccessibilityChildBehavior? = .ignore,
        @ViewBuilder label: () -> Label, 
        @ViewBuilder value: () -> Value = { EmptyView() },
        @ViewBuilder hint: () -> Hint = { EmptyView() }
    ) -> some View {
        modifier(AccessibilityLabelValueModifier(childBehavior: children, label: label, value: value, hint: hint))
    }
}

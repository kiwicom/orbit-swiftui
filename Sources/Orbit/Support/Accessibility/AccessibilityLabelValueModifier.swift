import SwiftUI

struct AccessibilityLabelValueModifier<Label: View, Value: View, Hint: View>: ViewModifier {
    
    @Environment(\.localizationBundle) private var localizationBundle
    @Environment(\.locale) private var locale
    
    @ViewBuilder let label: Label
    @ViewBuilder let value: Value
    @ViewBuilder let hint: Hint
    
    func body(content: Content) -> some View {
        if isLabelAndValueTextual {
            content
                .accessibilityElement(children: .ignore)
                .accessibility(label: textualLabel ?? SwiftUI.Text(""))
                .accessibility(value: textualValue ?? SwiftUI.Text(""))
                .accessibility(hint: textualHint ?? SwiftUI.Text(""))
        } else {
            content
                .accessibilityElement(children: .contain)
        }
    }
    
    private var isLabelAndValueTextual: Bool {
        textualLabel != nil 
        && (textualValue != nil || value is EmptyView)
        && (textualHint != nil || hint is EmptyView)
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
        @ViewBuilder label: () -> Label, 
        @ViewBuilder value: () -> Value = { EmptyView() },
        @ViewBuilder hint: () -> Hint = { EmptyView() }
    ) -> some View {
        modifier(AccessibilityLabelValueModifier(label: label, value: value, hint: hint))
    }
}

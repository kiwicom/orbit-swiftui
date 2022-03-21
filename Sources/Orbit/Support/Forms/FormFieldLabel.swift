import SwiftUI

/// Orbit label above form fields.
public struct FormFieldLabel: View {

    let label: String

    public var body: some View {
        Text(label, size: .normal, weight: .medium)
            .padding(.bottom, 1)
    }

    public init(_ label: String) {
        self.label = label
    }
}

// MARK: - Previews
struct FormFieldLabelPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FormFieldLabel("Form Field Label")
        }
        .previewLayout(.sizeThatFits)
    }
}

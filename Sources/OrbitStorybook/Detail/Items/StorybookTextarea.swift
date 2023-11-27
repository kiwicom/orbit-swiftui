import SwiftUI
import Orbit

struct StorybookTextarea {
    
    static let prompt = "Enter \(String(repeating: "values ", count: 20))"
    
    static var basic: some View {
        VStack(alignment: .leading, spacing: .medium) {
            textarea
            
            StateWrapper("") { $value in
                Textarea(value: $value, prompt: prompt)
                    .frame(height: 150)
            }
            
            HStack(alignment: .top, spacing: .medium) {
                textarea
                textarea
            }
        }
    }

    static var textarea: some View {
        StateWrapper(prompt) { $value in
            Textarea("Label", value: $value, prompt: prompt)
                .frame(height: 100)
        }
    }
}

struct StorybookTextareaPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTextarea.basic
                .padding(.medium)
        }
    }
}

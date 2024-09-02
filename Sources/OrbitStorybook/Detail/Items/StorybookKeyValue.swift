import SwiftUI
import Orbit

struct StorybookKeyValue {

    static let key = "Key"
    static let value = "Value"
    static let longValue = "Some very very very very very long value"

    static var basic: some View {
        VStack(alignment: .leading, spacing: .large) {
            KeyValue("Key", value: value)
            Separator()
            HStack(alignment: .firstTextBaseline, spacing: .large) {
                KeyValue("Key with no value")
                Spacer()
                KeyValue(value: "Value with no key")
            }
            Separator()
            HStack(alignment: .firstTextBaseline, spacing: .large) {
                KeyValue("Trailing very long key", value: longValue)
                    .multilineTextAlignment(.trailing)
                Spacer()
                KeyValue("Centered very long key", value: longValue)
                    .multilineTextAlignment(.center)
                Spacer()
                KeyValue("Leading very long key", value: longValue)
                    .multilineTextAlignment(.leading)
            }
        }
        .previewDisplayName()
    }
}

struct StorybookKeyValuePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookKeyValue.basic
        }
    }
}

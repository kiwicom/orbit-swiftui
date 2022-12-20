import SwiftUI
import Combine

extension View {

    @available(iOS, obsoleted: 14.0, renamed: "onChange")
    @ViewBuilder func valueChanged<T: Equatable>(_ value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { value in
                guard value != value else { return }
                onChange(value)
            }
        }
    }
}

import SwiftUI

/// Invisible line that maintains its vertical size.
///
/// Used to fix layout issues where `frame(minHeight:)` causes issues.
struct Strut: View {
    
    let height: CGFloat
    
    var body: some View {
        Color.clear
            .frame(width: 0, height: height)
    }
}

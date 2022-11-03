import SwiftUI

struct TimelineLine: View {
    var height: CGFloat
    var startPointStyle: TimelineItemStyle
    var endPointStyle: TimelineItemStyle

    var body: some View {
        coloredLine
            .frame(width: 2, height: height)
    }

    @ViewBuilder var coloredLine: some View {
        if endPointStyle.isLineDashed {
            linePath
                .fill(endPointStyle.color)
        } else {
            linePath
                .fill(LinearGradient(
                    colors: [startPointStyle.color, endPointStyle.color],
                    startPoint: .top,
                    endPoint: .bottom
                ))
        }
    }

    var linePath: some Shape {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
        }
        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: endPointStyle.isLineDashed ? [3, 5] : []))
    }
}

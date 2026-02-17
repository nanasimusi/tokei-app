//
//  ClockFaceView.swift
//  とけいであそぼ
//

import SwiftUI

struct ClockFaceView: View {
    let size: CGFloat
    let showAllNumbers: Bool
    let showMinuteMarks: Bool
    
    private var numberSize: CGFloat {
        size * 0.08
    }
    
    private var radius: CGFloat {
        size / 2
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.tokeiCanvas)
            
            // Border
            Circle()
                .stroke(Color.tokeiSubtle, lineWidth: 2)
            
            // Minute marks (60 small dots)
            if showMinuteMarks {
                ForEach(0..<60, id: \.self) { minute in
                    if minute % 5 != 0 {
                        Circle()
                            .fill(Color.tokeiSubtle)
                            .frame(width: 2, height: 2)
                            .offset(y: -radius + 15)
                            .rotationEffect(.degrees(Double(minute) * 6))
                    }
                }
            }
            
            // Hour marks (12 lines or dots)
            ForEach(0..<12, id: \.self) { hour in
                if showMinuteMarks {
                    // Line marks for detailed view
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.tokeiInkSecondary)
                        .frame(width: 2, height: 8)
                        .offset(y: -radius + 12)
                        .rotationEffect(.degrees(Double(hour) * 30))
                } else {
                    // Dot marks for simple view
                    Circle()
                        .fill(Color.tokeiSubtle)
                        .frame(width: 4, height: 4)
                        .offset(y: -radius + 20)
                        .rotationEffect(.degrees(Double(hour) * 30))
                }
            }
            
            // Numbers
            if showAllNumbers {
                // Show all 12 numbers
                ForEach(1...12, id: \.self) { hour in
                    numberView(for: hour)
                }
            } else {
                // Show only 12, 3, 6, 9
                ForEach([12, 3, 6, 9], id: \.self) { hour in
                    numberView(for: hour)
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private func numberView(for hour: Int) -> some View {
        let angle = Double(hour) * 30 - 90
        let numberRadius = radius - (showMinuteMarks ? 35 : 30)
        let x = cos(angle * .pi / 180) * numberRadius
        let y = sin(angle * .pi / 180) * numberRadius
        
        return Text("\(hour)")
            .font(TokeiTypography.clockNumber(size: numberSize))
            .foregroundColor(.tokeiInkPrimary)
            .position(x: size / 2 + x, y: size / 2 + y)
    }
}

#Preview("Simple") {
    ClockFaceView(
        size: 300,
        showAllNumbers: false,
        showMinuteMarks: false
    )
    .padding()
}

#Preview("Detailed") {
    ClockFaceView(
        size: 300,
        showAllNumbers: true,
        showMinuteMarks: true
    )
    .padding()
}

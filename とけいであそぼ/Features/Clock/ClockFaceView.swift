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
            
            // All 60 minute marks
            ForEach(0..<60, id: \.self) { minute in
                if minute % 5 == 0 {
                    // Hour marks (longer lines at 5-minute intervals)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.tokeiInkPrimary)
                        .frame(width: 2, height: 12)
                        .offset(y: -radius + 10)
                        .rotationEffect(.degrees(Double(minute) * 6))
                } else {
                    // Minute marks (small lines for each minute)
                    RoundedRectangle(cornerRadius: 0.5)
                        .fill(Color.tokeiSubtle)
                        .frame(width: 1, height: 6)
                        .offset(y: -radius + 10)
                        .rotationEffect(.degrees(Double(minute) * 6))
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

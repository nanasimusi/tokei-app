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
        size * 0.09
    }
    
    private var radius: CGFloat {
        size / 2
    }
    
    // Proportional sizing for Ive-inspired design
    private var hourMarkHeight: CGFloat { size * 0.06 }
    private var hourMarkWidth: CGFloat { size * 0.008 }
    private var minuteMarkHeight: CGFloat { size * 0.03 }
    private var minuteMarkWidth: CGFloat { size * 0.004 }
    private var markInset: CGFloat { size * 0.04 }
    
    var body: some View {
        ZStack {
            // Background - pure, clean
            Circle()
                .fill(Color.tokeiCanvas)
            
            // Subtle outer ring
            Circle()
                .stroke(Color.tokeiInkSecondary.opacity(0.2), lineWidth: 1)
            
            // All 60 minute marks - visible and precise
            ForEach(0..<60, id: \.self) { minute in
                if minute % 5 == 0 {
                    // Hour marks - bold and confident
                    RoundedRectangle(cornerRadius: hourMarkWidth / 2)
                        .fill(Color.tokeiInkPrimary)
                        .frame(width: hourMarkWidth, height: hourMarkHeight)
                        .offset(y: -radius + markInset + hourMarkHeight / 2)
                        .rotationEffect(.degrees(Double(minute) * 6))
                } else {
                    // Minute marks - subtle but clearly visible
                    RoundedRectangle(cornerRadius: minuteMarkWidth / 2)
                        .fill(Color.tokeiInkSecondary.opacity(0.6))
                        .frame(width: minuteMarkWidth, height: minuteMarkHeight)
                        .offset(y: -radius + markInset + minuteMarkHeight / 2)
                        .rotationEffect(.degrees(Double(minute) * 6))
                }
            }
            
            // Numbers - elegant typography
            if showAllNumbers {
                ForEach(1...12, id: \.self) { hour in
                    numberView(for: hour)
                }
            } else {
                ForEach([12, 3, 6, 9], id: \.self) { hour in
                    numberView(for: hour)
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private func numberView(for hour: Int) -> some View {
        let angle = Double(hour) * 30 - 90
        let numberRadius = radius * 0.72
        let x = cos(angle * .pi / 180) * numberRadius
        let y = sin(angle * .pi / 180) * numberRadius
        
        return Text("\(hour)")
            .font(.system(size: numberSize, weight: .medium, design: .rounded))
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

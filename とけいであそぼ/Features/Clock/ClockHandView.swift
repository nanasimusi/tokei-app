//
//  ClockHandView.swift
//  とけいであそぼ
//

import SwiftUI

struct ClockHandView: View {
    let length: CGFloat
    let width: CGFloat
    let color: Color
    let angle: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: width / 2)
            .fill(color)
            .frame(width: width, height: length)
            .offset(y: -length / 2)
            .rotationEffect(.degrees(angle))
    }
}

#Preview {
    ZStack {
        Circle()
            .stroke(Color.tokeiSubtle, lineWidth: 2)
            .frame(width: 200, height: 200)
        
        ClockHandView(
            length: 60,
            width: 4,
            color: .tokeiHour,
            angle: 90
        )
        
        ClockHandView(
            length: 80,
            width: 2.5,
            color: .tokeiMinute,
            angle: 180
        )
        
        Circle()
            .fill(Color.tokeiInkPrimary)
            .frame(width: 10, height: 10)
    }
}

//
//  SandboxView.swift
//  とけいであそぼ
//

import SwiftUI

struct SandboxView: View {
    @State private var currentTime = ClockTime(hour: 12, minute: 0)
    @State private var isDragging = false
    
    private let sandboxConfig = LevelConfig(
        id: 0,
        title: "あそび",
        subtitle: "",
        minuteGranularity: 1,
        showMinuteHand: true,
        showAllNumbers: true,
        showMinuteMarks: true,
        toleranceDegrees: 0,
        showDigitalTime: true
    )
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
                
                // Clock takes center stage - pure and focused
                AnalogClockView(
                    time: currentTime,
                    config: sandboxConfig,
                    isDragging: $isDragging,
                    onTimeChanged: { newTime in
                        currentTime = newTime
                        SpeechService.shared.speakTime(newTime)
                    }
                )
                .frame(height: geo.size.height * 0.60)
                
                // Time display - minimal and elegant
                VStack(spacing: 8) {
                    Text(currentTime.displayString)
                        .font(.system(size: geo.size.width * 0.15, weight: .light, design: .rounded))
                        .foregroundColor(.tokeiInkPrimary)
                        .monospacedDigit()
                    
                    Text(currentTime.japaneseReading)
                        .font(.system(size: geo.size.width * 0.06, weight: .medium, design: .rounded))
                        .foregroundColor(.tokeiInkSecondary)
                }
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .background(Color.tokeiCanvas)
        .navigationTitle("あそぶ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SandboxView()
    }
}

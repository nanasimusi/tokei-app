//
//  AnalogClockView.swift
//  とけいであそぼ
//

import SwiftUI

struct AnalogClockView: View {
    let time: ClockTime
    let config: LevelConfig
    @Binding var isDragging: Bool
    var onTimeChanged: ((ClockTime) -> Void)?
    var isInteractive: Bool = true
    
    @State private var currentHourAngle: Double = 0
    @State private var currentMinuteAngle: Double = 0
    @State private var dragStartAngle: Double = 0
    @State private var lastTickAngle: Double = 0
    
    var body: some View {
        GeometryReader { geo in
            // Use nearly full width for dramatic, Ive-inspired presence
            let size = min(geo.size.width, geo.size.height) * 0.95
            
            // Proportional hand dimensions
            let centerDotSize = size * 0.04
            let hourHandWidth = size * 0.02
            let minuteHandWidth = size * 0.012
            let hourHandLength = size * 0.28
            let minuteHandLength = size * 0.40
            
            ZStack {
                // Clock face
                ClockFaceView(
                    size: size,
                    showAllNumbers: config.showAllNumbers,
                    showMinuteMarks: config.showMinuteMarks
                )
                
                // Minute hand (if shown) - elegant and precise
                if config.showMinuteHand {
                    ClockHandView(
                        length: minuteHandLength,
                        width: minuteHandWidth,
                        color: .tokeiInkPrimary,
                        angle: currentMinuteAngle
                    )
                }
                
                // Hour hand - bold and confident
                ClockHandView(
                    length: hourHandLength,
                    width: hourHandWidth,
                    color: .tokeiInkPrimary,
                    angle: currentHourAngle
                )
                
                // Center dot - the focal point
                Circle()
                    .fill(Color.tokeiInkPrimary)
                    .frame(width: centerDotSize, height: centerDotSize)
                
                // Interactive drag area
                if isInteractive {
                    Circle()
                        .fill(Color.clear)
                        .contentShape(Circle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    handleDrag(value: value, size: size)
                                }
                                .onEnded { _ in
                                    handleDragEnd()
                                }
                        )
                }
            }
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            updateAngles(animated: false)
        }
        .onChange(of: time) { _, _ in
            updateAngles(animated: true)
        }
        .accessibilityLabel("アナログとけい。\(time.japaneseReading)")
        .accessibilityHint(isInteractive ? "はりを ドラッグして じかんを かえられます" : "")
    }
    
    private func updateAngles(animated: Bool) {
        if animated {
            withAnimation(TokeiAnimations.clockHand) {
                currentHourAngle = time.hourAngle
                currentMinuteAngle = time.minuteAngle
            }
        } else {
            currentHourAngle = time.hourAngle
            currentMinuteAngle = time.minuteAngle
        }
    }
    
    private func handleDrag(value: DragGesture.Value, size: CGFloat) {
        let center = CGPoint(x: size / 2, y: size / 2)
        let location = value.location
        
        // Calculate angle from center
        let dx = location.x - center.x
        let dy = location.y - center.y
        var angle = atan2(dy, dx) * 180 / .pi + 90
        if angle < 0 { angle += 360 }
        
        if !isDragging {
            isDragging = true
            dragStartAngle = angle
            lastTickAngle = angle
            TokeiHaptics.prepare()
        }
        
        // Determine which hand to move based on config
        if config.showMinuteHand {
            // Move minute hand, hour follows
            currentMinuteAngle = angle
            
            // Calculate corresponding hour angle
            let minute = Int(angle / 6) % 60
            let hour = Int(currentHourAngle / 30) % 12
            currentHourAngle = Double(hour) * 30 + Double(minute) * 0.5
            
            // Haptic feedback at 5-minute marks
            let fiveMinuteAngle = (Double(Int(angle / 30)) * 30)
            if abs(angle - fiveMinuteAngle) < 3 && abs(lastTickAngle - fiveMinuteAngle) >= 3 {
                TokeiHaptics.tick()
            }
            
            // Haptic feedback at hour marks
            let hourMarkAngle = (Double(Int(angle / 30)) * 30)
            if angle.truncatingRemainder(dividingBy: 30) < 2 && lastTickAngle.truncatingRemainder(dividingBy: 30) >= 2 {
                TokeiHaptics.hourMark()
            }
        } else {
            // Move hour hand only (for Level 1)
            currentHourAngle = angle
            
            // Haptic feedback at hour marks
            let hourMarkAngle = (Double(Int(angle / 30)) * 30)
            if abs(angle - hourMarkAngle) < 5 && abs(lastTickAngle - hourMarkAngle) >= 5 {
                TokeiHaptics.hourMark()
            }
        }
        
        lastTickAngle = angle
    }
    
    private func handleDragEnd() {
        isDragging = false
        
        // Snap to nearest valid position based on granularity
        let granularity = config.minuteGranularity
        
        var minute: Int
        var hour: Int
        
        if config.showMinuteHand {
            minute = Int(round(currentMinuteAngle / 6)) % 60
            minute = (minute / granularity) * granularity
            hour = Int(round(currentHourAngle / 30)) % 12
            if hour == 0 { hour = 12 }
        } else {
            minute = 0
            hour = Int(round(currentHourAngle / 30)) % 12
            if hour == 0 { hour = 12 }
        }
        
        let newTime = ClockTime(hour: hour, minute: minute)
        
        withAnimation(TokeiAnimations.clockHand) {
            currentHourAngle = newTime.hourAngle
            currentMinuteAngle = newTime.minuteAngle
        }
        
        onTimeChanged?(newTime)
    }
}

#Preview("Level 1 - Hour Only") {
    struct PreviewWrapper: View {
        @State var isDragging = false
        
        var body: some View {
            VStack {
                AnalogClockView(
                    time: ClockTime(hour: 3, minute: 0),
                    config: .level(1),
                    isDragging: $isDragging
                )
                .frame(height: 300)
                
                Text(isDragging ? "ドラッグ中..." : "はりを うごかしてね")
                    .tokeiBody()
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("Level 3 - Full") {
    struct PreviewWrapper: View {
        @State var isDragging = false
        @State var currentTime = ClockTime(hour: 10, minute: 35)
        
        var body: some View {
            VStack {
                AnalogClockView(
                    time: currentTime,
                    config: .level(3),
                    isDragging: $isDragging,
                    onTimeChanged: { newTime in
                        currentTime = newTime
                    }
                )
                .frame(height: 300)
                
                Text(currentTime.japaneseReading)
                    .tokeiTitle()
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

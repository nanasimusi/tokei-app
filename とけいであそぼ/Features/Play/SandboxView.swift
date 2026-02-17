//
//  SandboxView.swift
//  とけいであそぼ
//

import SwiftUI

struct SandboxView: View {
    @State private var currentTime = ClockTime(hour: 12, minute: 0)
    @State private var isDragging = false
    @State private var showDigital = true
    @State private var showAllNumbers = true
    @State private var showMinuteMarks = true
    
    private var sandboxConfig: LevelConfig {
        LevelConfig(
            id: 0,
            title: "あそび",
            subtitle: "",
            minuteGranularity: 1,
            showMinuteHand: true,
            showAllNumbers: showAllNumbers,
            showMinuteMarks: showMinuteMarks,
            toleranceDegrees: 0,
            showDigitalTime: showDigital
        )
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Interactive clock
            AnalogClockView(
                time: currentTime,
                config: sandboxConfig,
                isDragging: $isDragging,
                onTimeChanged: { newTime in
                    currentTime = newTime
                }
            )
            .frame(height: 300)
            
            // Time displays with speech button
            VStack(spacing: 8) {
                // Digital time
                if showDigital {
                    Text(currentTime.displayString)
                        .font(.system(size: 56, weight: .light, design: .rounded))
                        .foregroundColor(.tokeiInkPrimary)
                        .monospacedDigit()
                }
                
                // Japanese reading with speaker button
                HStack(spacing: 12) {
                    Text(currentTime.japaneseReading)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.tokeiInkSecondary)
                    
                    Button(action: {
                        SpeechService.shared.speakTime(currentTime)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.tokeiAccent)
                    }
                }
            }
            
            Spacer()
            
            // Quick time buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    QuickTimeButton(hour: 7, minute: 0, label: "あさ") { setTime($0, $1) }
                    QuickTimeButton(hour: 12, minute: 0, label: "おひる") { setTime($0, $1) }
                    QuickTimeButton(hour: 3, minute: 0, label: "おやつ") { setTime($0, $1) }
                    QuickTimeButton(hour: 6, minute: 30, label: "ゆうがた") { setTime($0, $1) }
                    QuickTimeButton(hour: 9, minute: 0, label: "よる") { setTime($0, $1) }
                }
                .padding(.horizontal, 24)
            }
            
            // Display toggles
            HStack(spacing: 20) {
                ToggleChip(label: "デジタル", isOn: $showDigital)
                ToggleChip(label: "すうじ", isOn: $showAllNumbers)
                ToggleChip(label: "めもり", isOn: $showMinuteMarks)
            }
            .padding(.bottom, 24)
        }
        .background(Color.tokeiCanvas)
        .navigationTitle("あそぶ")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func setTime(_ hour: Int, _ minute: Int) {
        withAnimation(TokeiAnimations.clockHand) {
            currentTime = ClockTime(hour: hour, minute: minute)
        }
    }
}

struct QuickTimeButton: View {
    let hour: Int
    let minute: Int
    let label: String
    let action: (Int, Int) -> Void
    
    var body: some View {
        Button(action: { action(hour, minute) }) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.tokeiInkPrimary)
                
                Text("\(hour):\(String(format: "%02d", minute))")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.tokeiInkSecondary)
                    .monospacedDigit()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct ToggleChip: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            Text(label)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(isOn ? .white : .tokeiInkSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isOn ? Color.tokeiAccent : Color.tokeiSubtle)
                )
        }
    }
}

#Preview {
    NavigationStack {
        SandboxView()
    }
}

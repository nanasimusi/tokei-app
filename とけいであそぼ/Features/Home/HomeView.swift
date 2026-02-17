//
//  HomeView.swift
//  とけいであそぼ
//

import SwiftUI
import Combine

struct HomeView: View {
    @State private var currentTime = ClockTime.current
    @State private var isDragging = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // Clock dominates the view - Ive-inspired visual hierarchy
                    AnalogClockView(
                        time: currentTime,
                        config: LevelConfig(
                            id: 0,
                            title: "",
                            subtitle: "",
                            minuteGranularity: 1,
                            showMinuteHand: true,
                            showAllNumbers: true,
                            showMinuteMarks: true,
                            toleranceDegrees: 0,
                            showDigitalTime: true
                        ),
                        isDragging: $isDragging,
                        isInteractive: false
                    )
                    .frame(height: geo.size.height * 0.50)
                    .padding(.top, 20)
                    
                    // Digital time - understated elegance
                    Text(currentTime.displayString)
                        .font(.system(size: geo.size.width * 0.12, weight: .light, design: .rounded))
                        .foregroundColor(.tokeiInkPrimary)
                        .monospacedDigit()
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    // Navigation buttons - minimal and functional
                    VStack(spacing: 12) {
                        NavigationLink(destination: SandboxView()) {
                            HomeButton(
                                title: "あそぶ",
                                subtitle: "じゆうに うごかそう",
                                systemImage: "hand.draw.fill"
                            )
                        }
                        
                        NavigationLink(destination: SettingsView()) {
                            HomeButton(
                                title: "せってい",
                                subtitle: "",
                                systemImage: "gearshape.fill",
                                isCompact: true
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.tokeiCanvas)
            .onReceive(timer) { _ in
                if !isDragging {
                    withAnimation(TokeiAnimations.clockHand) {
                        currentTime = ClockTime.current
                    }
                }
            }
        }
    }
}

struct HomeButton: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var isCompact: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: isCompact ? 20 : 24, weight: .medium))
                .foregroundColor(.tokeiInkPrimary)
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: isCompact ? 18 : 22, weight: .semibold, design: .rounded))
                    .foregroundColor(.tokeiInkPrimary)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.tokeiInkSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.tokeiInkSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, isCompact ? 14 : 18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

#Preview {
    HomeView()
}

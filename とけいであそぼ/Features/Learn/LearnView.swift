//
//  LearnView.swift
//  とけいであそぼ
//

import SwiftUI

struct LearnView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(LevelConfig.levels) { level in
                    NavigationLink(destination: LevelView(level: level)) {
                        LevelCard(level: level)
                    }
                }
            }
            .padding(24)
        }
        .background(Color.tokeiCanvas)
        .navigationTitle("まなぶ")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct LevelCard: View {
    let level: LevelConfig
    
    var body: some View {
        HStack(spacing: 16) {
            // Level number
            Text("\(level.id)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.tokeiAccent)
                .frame(width: 50)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(level.title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.tokeiInkPrimary)
                
                Text(level.subtitle)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.tokeiInkSecondary)
            }
            
            Spacer()
            
            // Preview clock
            MiniClockView(config: level)
                .frame(width: 50, height: 50)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.tokeiInkSecondary)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

struct MiniClockView: View {
    let config: LevelConfig
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.tokeiSubtle, lineWidth: 1.5)
            
            // Hour hand
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.tokeiHour)
                .frame(width: 2, height: 14)
                .offset(y: -7)
                .rotationEffect(.degrees(90))
            
            // Minute hand (if shown)
            if config.showMinuteHand {
                RoundedRectangle(cornerRadius: 0.5)
                    .fill(Color.tokeiMinute)
                    .frame(width: 1.5, height: 18)
                    .offset(y: -9)
                    .rotationEffect(.degrees(0))
            }
            
            Circle()
                .fill(Color.tokeiInkPrimary)
                .frame(width: 4, height: 4)
        }
    }
}

#Preview {
    NavigationStack {
        LearnView()
    }
}

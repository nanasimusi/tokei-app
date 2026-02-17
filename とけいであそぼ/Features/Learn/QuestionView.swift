//
//  QuestionView.swift
//  とけいであそぼ
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    let config: LevelConfig
    let onAnswer: (Bool) -> Void
    
    @State private var isDragging = false
    @State private var userTime = ClockTime(hour: 12, minute: 0)
    @State private var selectedOption: ClockTime?
    @State private var selectedHour: Int = 12
    
    var body: some View {
        VStack(spacing: 32) {
            // Prompt
            Text(question.prompt)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.tokeiInkPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // Question content based on type
            switch question.type {
            case .readTime:
                readTimeView
            case .setTime:
                setTimeView
            case .chooseTime:
                chooseTimeView
            case .matchEvent:
                matchEventView
            case .calculateTime:
                calculateTimeView
            }
        }
    }
    
    // MARK: - Read Time View
    private var readTimeView: some View {
        VStack(spacing: 24) {
            AnalogClockView(
                time: question.targetTime,
                config: config,
                isDragging: $isDragging,
                isInteractive: false
            )
            .frame(height: 250)
            
            // Hour picker for Level 1
            if config.id == 1 {
                hourPicker
            } else {
                // Digital input for higher levels
                digitalTimePicker
            }
        }
    }
    
    // MARK: - Set Time View
    private var setTimeView: some View {
        VStack(spacing: 24) {
            AnalogClockView(
                time: userTime,
                config: config,
                isDragging: $isDragging,
                onTimeChanged: { newTime in
                    userTime = newTime
                }
            )
            .frame(height: 250)
            
            if config.showDigitalTime {
                Text(userTime.displayString)
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                    .foregroundColor(.tokeiInkSecondary)
                    .monospacedDigit()
            }
            
            Button(action: checkSetTimeAnswer) {
                Text("これでいい！")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.tokeiAccent)
                    )
            }
        }
    }
    
    // MARK: - Choose Time View
    private var chooseTimeView: some View {
        VStack(spacing: 24) {
            if let options = question.options {
                HStack(spacing: 20) {
                    ForEach(options, id: \.hourAngle) { option in
                        Button(action: {
                            selectedOption = option
                            checkChooseAnswer(selected: option)
                        }) {
                            VStack {
                                ZStack {
                                    Circle()
                                        .stroke(
                                            selectedOption == option ? Color.tokeiAccent : Color.tokeiSubtle,
                                            lineWidth: selectedOption == option ? 3 : 2
                                        )
                                        .frame(width: 140, height: 140)
                                    
                                    AnalogClockView(
                                        time: option,
                                        config: config,
                                        isDragging: .constant(false),
                                        isInteractive: false
                                    )
                                    .frame(width: 120, height: 120)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Match Event View
    private var matchEventView: some View {
        VStack(spacing: 24) {
            if let eventName = question.eventName {
                Text(eventName)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.tokeiAccent)
            }
            
            AnalogClockView(
                time: question.targetTime,
                config: config,
                isDragging: $isDragging,
                isInteractive: false
            )
            .frame(height: 200)
            
            Button(action: { onAnswer(true) }) {
                Text("つぎへ")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.tokeiAccent)
                    )
            }
        }
    }
    
    // MARK: - Calculate Time View
    private var calculateTimeView: some View {
        VStack(spacing: 24) {
            if let startTime = question.startTime {
                HStack(spacing: 20) {
                    VStack {
                        Text("はじめ")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.tokeiInkSecondary)
                        
                        AnalogClockView(
                            time: startTime,
                            config: config,
                            isDragging: .constant(false),
                            isInteractive: false
                        )
                        .frame(width: 120, height: 120)
                    }
                    
                    VStack {
                        Text("+\(question.durationMinutes ?? 0)ふん")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.tokeiAccent)
                    }
                    
                    VStack {
                        Text("おわり")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.tokeiInkSecondary)
                        
                        AnalogClockView(
                            time: userTime,
                            config: config,
                            isDragging: $isDragging,
                            onTimeChanged: { newTime in
                                userTime = newTime
                            }
                        )
                        .frame(width: 120, height: 120)
                    }
                }
            }
            
            Button(action: checkSetTimeAnswer) {
                Text("これでいい！")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.tokeiAccent)
                    )
            }
        }
    }
    
    // MARK: - Hour Picker (for Level 1)
    private var hourPicker: some View {
        VStack(spacing: 16) {
            // Hour grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(1...12, id: \.self) { hour in
                    Button(action: {
                        selectedHour = hour
                    }) {
                        Text("\(hour)")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundColor(selectedHour == hour ? .white : .tokeiInkPrimary)
                            .frame(width: 56, height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedHour == hour ? Color.tokeiAccent : Color.tokeiSubtle.opacity(0.5))
                            )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Button(action: checkHourAnswer) {
                Text("これでいい！")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.tokeiAccent)
                    )
            }
        }
    }
    
    // MARK: - Digital Time Picker
    private var digitalTimePicker: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Picker("Hour", selection: $selectedHour) {
                    ForEach(1...12, id: \.self) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80)
                
                Text(":")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                
                Picker("Minute", selection: Binding(
                    get: { userTime.minute },
                    set: { userTime = ClockTime(hour: selectedHour, minute: $0) }
                )) {
                    ForEach(0..<60, id: \.self) { minute in
                        if minute % config.minuteGranularity == 0 {
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80)
            }
            .frame(height: 120)
            
            Button(action: checkDigitalAnswer) {
                Text("これでいい！")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.tokeiAccent)
                    )
            }
        }
    }
    
    // MARK: - Answer Checking
    private func checkHourAnswer() {
        let correct = selectedHour == question.targetTime.hour ||
                      (selectedHour == 12 && question.targetTime.hour == 0)
        onAnswer(correct)
    }
    
    private func checkSetTimeAnswer() {
        let correct = userTime.matches(question.targetTime, minuteTolerance: config.toleranceMinutes)
        onAnswer(correct)
    }
    
    private func checkChooseAnswer(selected: ClockTime) {
        let correct = selected == question.targetTime
        onAnswer(correct)
    }
    
    private func checkDigitalAnswer() {
        let userAnswer = ClockTime(hour: selectedHour, minute: userTime.minute)
        let correct = userAnswer.matches(question.targetTime, minuteTolerance: config.toleranceMinutes)
        onAnswer(correct)
    }
}

#Preview("Read Time") {
    QuestionView(
        question: Question(
            type: .readTime,
            level: 1,
            targetTime: ClockTime(hour: 3, minute: 0),
            prompt: "いま なんじ？",
            skillId: "hour_3"
        ),
        config: .level(1),
        onAnswer: { _ in }
    )
}

#Preview("Set Time") {
    QuestionView(
        question: Question(
            type: .setTime,
            level: 2,
            targetTime: ClockTime(hour: 6, minute: 30),
            prompt: "6じはんに してね",
            skillId: "half_6_30"
        ),
        config: .level(2),
        onAnswer: { _ in }
    )
}

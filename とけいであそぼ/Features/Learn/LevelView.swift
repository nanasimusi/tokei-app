//
//  LevelView.swift
//  とけいであそぼ
//

import SwiftUI

struct LevelView: View {
    let level: LevelConfig
    
    @State private var currentPhase: LearningPhase = .introduction
    @State private var currentQuestion: Question?
    @State private var showingResult = false
    @State private var isCorrect = false
    @State private var questionsAnswered = 0
    @State private var correctAnswers = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            ProgressBar(
                current: questionsAnswered,
                total: 5,
                phase: currentPhase
            )
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer()
            
            // Question content
            if let question = currentQuestion {
                QuestionView(
                    question: question,
                    config: level,
                    onAnswer: handleAnswer
                )
            } else {
                // Introduction or completion
                if questionsAnswered >= 5 {
                    LevelCompleteView(
                        correct: correctAnswers,
                        total: 5,
                        onContinue: resetLevel
                    )
                } else {
                    PhaseIntroView(phase: currentPhase, level: level)
                        .onAppear {
                            generateQuestion()
                        }
                }
            }
            
            Spacer()
        }
        .background(Color.tokeiCanvas)
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if showingResult {
                ResultOverlay(isCorrect: isCorrect) {
                    showingResult = false
                    if questionsAnswered < 5 {
                        generateQuestion()
                    } else {
                        currentQuestion = nil
                    }
                }
            }
        }
    }
    
    private func generateQuestion() {
        currentQuestion = QuestionGenerator.generateForLevel(level.id, phase: currentPhase)
    }
    
    private func handleAnswer(correct: Bool) {
        isCorrect = correct
        questionsAnswered += 1
        if correct {
            correctAnswers += 1
            TokeiHaptics.success()
        }
        showingResult = true
        
        // Advance phase after successful answers
        if correct && questionsAnswered % 2 == 0 {
            advancePhase()
        }
    }
    
    private func advancePhase() {
        let phases = LearningPhase.allCases
        if let currentIndex = phases.firstIndex(of: currentPhase),
           currentIndex < phases.count - 1 {
            currentPhase = phases[currentIndex + 1]
        }
    }
    
    private func resetLevel() {
        currentPhase = .introduction
        questionsAnswered = 0
        correctAnswers = 0
        currentQuestion = nil
        generateQuestion()
    }
}

struct ProgressBar: View {
    let current: Int
    let total: Int
    let phase: LearningPhase
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(phase.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.tokeiInkSecondary)
                
                Spacer()
                
                Text("\(current)/\(total)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.tokeiInkSecondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.tokeiSubtle)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.tokeiAccent)
                        .frame(width: geo.size.width * CGFloat(current) / CGFloat(total))
                        .animation(TokeiAnimations.standard, value: current)
                }
            }
            .frame(height: 8)
        }
    }
}

struct PhaseIntroView: View {
    let phase: LearningPhase
    let level: LevelConfig
    
    var body: some View {
        VStack(spacing: 24) {
            Text(phaseDescription)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.tokeiInkPrimary)
                .multilineTextAlignment(.center)
            
            Text(phaseHint)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.tokeiInkSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
    
    private var phaseDescription: String {
        switch phase {
        case .introduction: return "とけいを みてみよう"
        case .recognition: return "どっちかな？"
        case .reproduction: return "はりを うごかそう"
        case .application: return "なんじ？"
        }
    }
    
    private var phaseHint: String {
        switch phase {
        case .introduction: return "じかんと とけいを おぼえよう"
        case .recognition: return "ただしい とけいを えらぼう"
        case .reproduction: return "じぶんで とけいを あわせよう"
        case .application: return "とけいを よんでみよう"
        }
    }
}

struct LevelCompleteView: View {
    let correct: Int
    let total: Int
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Text("おわり！")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.tokeiInkPrimary)
            
            VStack(spacing: 8) {
                Text("\(correct)/\(total)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.tokeiAccent)
                
                Text("せいかい")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.tokeiInkSecondary)
            }
            
            Button(action: onContinue) {
                Text("もういちど")
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
}

struct ResultOverlay: View {
    let isCorrect: Bool
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 16) {
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.tokeiAccent)
                    
                    Text("せいかい！")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.tokeiInkPrimary)
                } else {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.tokeiInkSecondary)
                    
                    Text("もういちど")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.tokeiInkPrimary)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.tokeiCanvas)
            )
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(TokeiAnimations.success) {
                scale = 1
                opacity = 1
            }
            
            // Speak result
            if isCorrect {
                SpeechService.shared.speakCorrect()
            } else {
                SpeechService.shared.speakTryAgain()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        }
    }
    
    private func dismiss() {
        withAnimation(TokeiAnimations.quick) {
            scale = 0.8
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

#Preview {
    NavigationStack {
        LevelView(level: .level(1))
    }
}

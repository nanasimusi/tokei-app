//
//  Question.swift
//  とけいであそぼ
//

import Foundation

enum QuestionType {
    case readTime           // Show clock, ask what time
    case setTime            // Give time, set the clock
    case chooseTime         // Show clock, choose from options
    case matchEvent         // Match event to time
    case calculateTime      // Time arithmetic
}

struct Question: Identifiable {
    let id = UUID()
    let type: QuestionType
    let level: Int
    let targetTime: ClockTime
    let prompt: String
    let options: [ClockTime]?
    let eventName: String?
    let skillId: String
    
    // For time calculation questions
    let startTime: ClockTime?
    let durationMinutes: Int?
    
    init(
        type: QuestionType,
        level: Int,
        targetTime: ClockTime,
        prompt: String,
        options: [ClockTime]? = nil,
        eventName: String? = nil,
        skillId: String,
        startTime: ClockTime? = nil,
        durationMinutes: Int? = nil
    ) {
        self.type = type
        self.level = level
        self.targetTime = targetTime
        self.prompt = prompt
        self.options = options
        self.eventName = eventName
        self.skillId = skillId
        self.startTime = startTime
        self.durationMinutes = durationMinutes
    }
}

struct QuestionGenerator {
    static func generateForLevel(_ level: Int, phase: LearningPhase) -> Question {
        let config = LevelConfig.level(level)
        
        switch (level, phase) {
        case (1, .introduction), (1, .recognition):
            return generateHourQuestion(phase: phase)
        case (1, .reproduction), (1, .application):
            return generateHourQuestion(phase: phase)
        case (2, _):
            return generateHalfHourQuestion(phase: phase)
        case (3, _):
            return generateFiveMinuteQuestion(phase: phase)
        case (4, _):
            return generatePreciseQuestion(phase: phase)
        case (5, _):
            return generateCalculationQuestion()
        default:
            return generateHourQuestion(phase: .application)
        }
    }
    
    private static func generateHourQuestion(phase: LearningPhase) -> Question {
        let hour = Int.random(in: 1...12)
        let time = ClockTime(hour: hour, minute: 0)
        
        switch phase {
        case .introduction:
            return Question(
                type: .matchEvent,
                level: 1,
                targetTime: time,
                prompt: eventPrompt(for: hour),
                eventName: eventName(for: hour),
                skillId: "hour_\(hour)"
            )
        case .recognition:
            let wrongHour = (hour + Int.random(in: 1...6)) % 12 + 1
            let options = [time, ClockTime(hour: wrongHour, minute: 0)].shuffled()
            return Question(
                type: .chooseTime,
                level: 1,
                targetTime: time,
                prompt: "\(hour)じは どっち？",
                options: options,
                skillId: "hour_\(hour)"
            )
        case .reproduction:
            return Question(
                type: .setTime,
                level: 1,
                targetTime: time,
                prompt: "\(hour)じに してね",
                skillId: "hour_\(hour)"
            )
        case .application:
            return Question(
                type: .readTime,
                level: 1,
                targetTime: time,
                prompt: "いま なんじ？",
                skillId: "hour_\(hour)"
            )
        }
    }
    
    private static func generateHalfHourQuestion(phase: LearningPhase) -> Question {
        let hour = Int.random(in: 1...12)
        let minute = [0, 30].randomElement()!
        let time = ClockTime(hour: hour, minute: minute)
        
        let prompt = minute == 0 ? "\(hour)じ" : "\(hour)じはん"
        
        switch phase {
        case .introduction, .recognition:
            let wrongMinute = minute == 0 ? 30 : 0
            let options = [time, ClockTime(hour: hour, minute: wrongMinute)].shuffled()
            return Question(
                type: .chooseTime,
                level: 2,
                targetTime: time,
                prompt: "\(prompt)は どっち？",
                options: options,
                skillId: "half_\(hour)_\(minute)"
            )
        case .reproduction:
            return Question(
                type: .setTime,
                level: 2,
                targetTime: time,
                prompt: "\(prompt)に してね",
                skillId: "half_\(hour)_\(minute)"
            )
        case .application:
            return Question(
                type: .readTime,
                level: 2,
                targetTime: time,
                prompt: "いま なんじ？",
                skillId: "half_\(hour)_\(minute)"
            )
        }
    }
    
    private static func generateFiveMinuteQuestion(phase: LearningPhase) -> Question {
        let hour = Int.random(in: 1...12)
        let minute = Int.random(in: 0...11) * 5
        let time = ClockTime(hour: hour, minute: minute)
        
        return Question(
            type: phase == .reproduction ? .setTime : .readTime,
            level: 3,
            targetTime: time,
            prompt: phase == .reproduction ? "\(time.japaneseReading)に してね" : "いま なんじ？",
            skillId: "five_\(hour)_\(minute)"
        )
    }
    
    private static func generatePreciseQuestion(phase: LearningPhase) -> Question {
        let hour = Int.random(in: 1...12)
        let minute = Int.random(in: 0...59)
        let time = ClockTime(hour: hour, minute: minute)
        
        return Question(
            type: phase == .reproduction ? .setTime : .readTime,
            level: 4,
            targetTime: time,
            prompt: phase == .reproduction ? "\(time.japaneseReading)に してね" : "いま なんじ？",
            skillId: "precise_\(hour)_\(minute)"
        )
    }
    
    private static func generateCalculationQuestion() -> Question {
        let startHour = Int.random(in: 1...10)
        let startMinute = Int.random(in: 0...11) * 5
        let duration = [15, 30, 45, 60].randomElement()!
        
        let startTime = ClockTime(hour: startHour, minute: startMinute)
        let endMinutes = startHour * 60 + startMinute + duration
        let endTime = ClockTime(hour: (endMinutes / 60) % 12, minute: endMinutes % 60)
        
        return Question(
            type: .calculateTime,
            level: 5,
            targetTime: endTime,
            prompt: "\(startTime.japaneseReading)から \(duration)ふんご は なんじ？",
            skillId: "calc_\(duration)",
            startTime: startTime,
            durationMinutes: duration
        )
    }
    
    private static func eventName(for hour: Int) -> String {
        switch hour {
        case 7: return "あさごはん"
        case 8: return "がっこう"
        case 12: return "おひるごはん"
        case 3: return "おやつ"
        case 6: return "ばんごはん"
        case 9: return "ねるじかん"
        default: return "とけい"
        }
    }
    
    private static func eventPrompt(for hour: Int) -> String {
        let event = eventName(for: hour)
        return "\(event)は \(hour)じ"
    }
}

enum LearningPhase: String, CaseIterable {
    case introduction = "どうにゅう"
    case recognition = "にんしき"
    case reproduction = "さいせい"
    case application = "おうよう"
}

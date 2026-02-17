//
//  SkillMastery.swift
//  とけいであそぼ
//

import Foundation
import SwiftData

enum MasteryLevel: String, Codable {
    case introduced = "はじめまして"
    case learning = "れんしゅうちゅう"
    case practicing = "もうすこし"
    case mastered = "できた"
    
    var emoji: String {
        switch self {
        case .introduced: return "🌱"
        case .learning: return "🌿"
        case .practicing: return "🌳"
        case .mastered: return "🌸"
        }
    }
}

@Model
class SkillMastery {
    var skillId: String
    var level: Int
    var correctStreak: Int
    var totalAttempts: Int
    var correctAttempts: Int
    var averageResponseTime: TimeInterval
    var lastPracticed: Date?
    var easeFactor: Double
    var interval: Int
    var nextReviewDate: Date?
    
    init(
        skillId: String,
        level: Int,
        correctStreak: Int = 0,
        totalAttempts: Int = 0,
        correctAttempts: Int = 0,
        averageResponseTime: TimeInterval = 0,
        easeFactor: Double = 2.5,
        interval: Int = 1
    ) {
        self.skillId = skillId
        self.level = level
        self.correctStreak = correctStreak
        self.totalAttempts = totalAttempts
        self.correctAttempts = correctAttempts
        self.averageResponseTime = averageResponseTime
        self.easeFactor = easeFactor
        self.interval = interval
    }
    
    var masteryLevel: MasteryLevel {
        let accuracy = totalAttempts > 0 ? Double(correctAttempts) / Double(totalAttempts) : 0
        switch (accuracy, correctStreak) {
        case (0.9..., 5...): return .mastered
        case (0.7..., 3...): return .practicing
        case (0.5..., _): return .learning
        default: return .introduced
        }
    }
    
    var isDueForReview: Bool {
        guard let nextReview = nextReviewDate else { return false }
        return Date() >= nextReview
    }
    
    func recordAttempt(correct: Bool, responseTime: TimeInterval) {
        totalAttempts += 1
        
        if correct {
            correctAttempts += 1
            correctStreak += 1
            
            // SM-2 algorithm update (simplified)
            let adjustment = 0.1 - 0.08 - 0.02
            easeFactor = max(1.3, easeFactor + adjustment)
            
            if correctStreak == 1 {
                interval = 1
            } else if correctStreak == 2 {
                interval = 6
            } else {
                interval = Int(Double(interval) * easeFactor)
            }
        } else {
            correctStreak = 0
            interval = 1
        }
        
        // Update average response time
        let totalTime = averageResponseTime * Double(totalAttempts - 1) + responseTime
        averageResponseTime = totalTime / Double(totalAttempts)
        
        lastPracticed = Date()
        nextReviewDate = Calendar.current.date(byAdding: .day, value: interval, to: Date())
    }
}

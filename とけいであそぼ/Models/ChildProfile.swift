//
//  ChildProfile.swift
//  とけいであそぼ
//

import Foundation
import SwiftData

@Model
class ChildProfile {
    var name: String
    var birthDate: Date?
    var currentLevel: Int
    @Relationship(deleteRule: .cascade) var skills: [SkillMastery]
    var totalPracticeTime: TimeInterval
    var lastSessionDate: Date?
    var dailyPracticeGoal: TimeInterval
    var streakDays: Int
    var createdAt: Date
    
    init(
        name: String = "",
        birthDate: Date? = nil,
        currentLevel: Int = 1,
        dailyPracticeGoal: TimeInterval = 600
    ) {
        self.name = name
        self.birthDate = birthDate
        self.currentLevel = currentLevel
        self.skills = []
        self.totalPracticeTime = 0
        self.dailyPracticeGoal = dailyPracticeGoal
        self.streakDays = 0
        self.createdAt = Date()
    }
    
    var age: Int? {
        guard let birthDate else { return nil }
        return Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year
    }
    
    var todayPracticeTime: TimeInterval {
        guard let lastSession = lastSessionDate,
              Calendar.current.isDateInToday(lastSession) else {
            return 0
        }
        return totalPracticeTime
    }
    
    func skill(for id: String) -> SkillMastery? {
        skills.first { $0.skillId == id }
    }
    
    func addSkill(_ skill: SkillMastery) {
        skills.append(skill)
    }
    
    func updateStreak() {
        if let lastSession = lastSessionDate {
            let calendar = Calendar.current
            if calendar.isDateInYesterday(lastSession) {
                streakDays += 1
            } else if !calendar.isDateInToday(lastSession) {
                streakDays = 1
            }
        } else {
            streakDays = 1
        }
        lastSessionDate = Date()
    }
}

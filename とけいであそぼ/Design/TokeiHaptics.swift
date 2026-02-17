//
//  TokeiHaptics.swift
//  とけいであそぼ
//

import UIKit

struct TokeiHaptics {
    private static let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private static let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private static let notification = UINotificationFeedbackGenerator()
    
    // Prepare generators for immediate response
    static func prepare() {
        lightImpact.prepare()
        mediumImpact.prepare()
        notification.prepare()
    }
    
    // Light tap - for 5-minute marks
    static func tick() {
        lightImpact.impactOccurred()
    }
    
    // Medium tap - for hour marks
    static func hourMark() {
        mediumImpact.impactOccurred()
    }
    
    // Success feedback - for correct answers
    static func success() {
        notification.notificationOccurred(.success)
    }
    
    // Gentle warning - for hints
    static func hint() {
        lightImpact.impactOccurred(intensity: 0.5)
    }
}

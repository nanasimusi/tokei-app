//
//  TokeiAnimations.swift
//  とけいであそぼ
//

import SwiftUI

struct TokeiAnimations {
    // Standard spring animation for all transitions
    static let standard = Animation.spring(response: 0.5, dampingFraction: 0.8)
    
    // Quick feedback animation
    static let quick = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    // Slow, gentle animation for clock hands
    static let clockHand = Animation.spring(response: 0.6, dampingFraction: 0.85)
    
    // Success feedback animation
    static let success = Animation.spring(response: 0.4, dampingFraction: 0.6)
    
    // Subtle pulse for hints
    static let pulse = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
}

extension View {
    func tokeiAnimation() -> some View {
        self.animation(TokeiAnimations.standard, value: UUID())
    }
    
    func withTokeiSpring() -> some View {
        self.animation(TokeiAnimations.standard, value: true)
    }
}

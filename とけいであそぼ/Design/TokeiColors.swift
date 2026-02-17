//
//  TokeiColors.swift
//  とけいであそぼ
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct TokeiColors {
    // Neutral Base - Warm minimalist palette
    static let canvas = Color(hex: "FAFAF8")
    static let inkPrimary = Color(hex: "1A1A1A")
    static let inkSecondary = Color(hex: "8E8E93")
    static let subtle = Color(hex: "E8E6E1")
    
    // Clock hands
    static let hour = Color(hex: "2C2C2E")
    static let minute = Color(hex: "636366")
    
    // Accent - Warm orange for feedback
    static let accent = Color(hex: "FF6B35")
    static let accentSoft = Color(hex: "FFF0E8")
    
    // Dark mode variants
    static let canvasDark = Color(hex: "1C1C1E")
    static let inkDark = Color(hex: "F5F5F5")
}

extension Color {
    static let tokeiCanvas = TokeiColors.canvas
    static let tokeiInkPrimary = TokeiColors.inkPrimary
    static let tokeiInkSecondary = TokeiColors.inkSecondary
    static let tokeiSubtle = TokeiColors.subtle
    static let tokeiHour = TokeiColors.hour
    static let tokeiMinute = TokeiColors.minute
    static let tokeiAccent = TokeiColors.accent
    static let tokeiAccentSoft = TokeiColors.accentSoft
}

//
//  LevelConfig.swift
//  とけいであそぼ
//

import Foundation

struct LevelConfig: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let minuteGranularity: Int
    let showMinuteHand: Bool
    let showAllNumbers: Bool
    let showMinuteMarks: Bool
    let toleranceDegrees: Double
    let showDigitalTime: Bool
    
    // Tolerance in minutes for answer checking
    var toleranceMinutes: Int {
        Int(toleranceDegrees / 6.0)
    }
}

extension LevelConfig {
    static let levels: [LevelConfig] = [
        LevelConfig(
            id: 1,
            title: "いまなんじ？",
            subtitle: "ちょうどの じかん",
            minuteGranularity: 60,
            showMinuteHand: false,
            showAllNumbers: false,
            showMinuteMarks: false,
            toleranceDegrees: 15,
            showDigitalTime: false
        ),
        LevelConfig(
            id: 2,
            title: "はんぶん",
            subtitle: "30ぷん",
            minuteGranularity: 30,
            showMinuteHand: true,
            showAllNumbers: false,
            showMinuteMarks: false,
            toleranceDegrees: 12,
            showDigitalTime: false
        ),
        LevelConfig(
            id: 3,
            title: "いつつずつ",
            subtitle: "5ふん きざみ",
            minuteGranularity: 5,
            showMinuteHand: true,
            showAllNumbers: true,
            showMinuteMarks: true,
            toleranceDegrees: 8,
            showDigitalTime: true
        ),
        LevelConfig(
            id: 4,
            title: "ぴったり",
            subtitle: "1ぷん きざみ",
            minuteGranularity: 1,
            showMinuteHand: true,
            showAllNumbers: true,
            showMinuteMarks: true,
            toleranceDegrees: 4,
            showDigitalTime: true
        ),
        LevelConfig(
            id: 5,
            title: "じかんのけいさん",
            subtitle: "たしざん ひきざん",
            minuteGranularity: 5,
            showMinuteHand: true,
            showAllNumbers: true,
            showMinuteMarks: true,
            toleranceDegrees: 6,
            showDigitalTime: true
        )
    ]
    
    static func level(_ id: Int) -> LevelConfig {
        levels.first { $0.id == id } ?? levels[0]
    }
}

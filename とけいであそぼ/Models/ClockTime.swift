//
//  ClockTime.swift
//  とけいであそぼ
//

import Foundation

struct ClockTime: Equatable {
    var hour: Int
    var minute: Int
    
    init(hour: Int, minute: Int) {
        self.hour = hour % 12 == 0 ? 12 : hour % 12
        self.minute = minute % 60
    }
    
    static var current: ClockTime {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        return ClockTime(hour: components.hour ?? 12, minute: components.minute ?? 0)
    }
    
    // Hour angle in degrees (0 = 12 o'clock)
    var hourAngle: Double {
        let hourPart = Double(hour % 12) * 30.0
        let minutePart = Double(minute) * 0.5
        return hourPart + minutePart
    }
    
    // Minute angle in degrees (0 = 12 o'clock)
    var minuteAngle: Double {
        Double(minute) * 6.0
    }
    
    // Display string for digital time
    var displayString: String {
        let displayHour = hour == 0 ? 12 : hour
        return String(format: "%d:%02d", displayHour, minute)
    }
    
    // Japanese reading for display
    var japaneseReading: String {
        let hourStr = "\(hour)じ"
        if minute == 0 {
            return hourStr
        } else if minute == 30 {
            return "\(hourStr)はん"
        } else {
            return "\(hourStr)\(minute)ふん"
        }
    }
    
    // Japanese reading for speech synthesis
    var spokenJapanese: String {
        let hourReading = spokenHour(hour)
        
        if minute == 0 {
            return "\(hourReading)"
        } else if minute == 30 {
            return "\(hourReading)はん"
        } else {
            return "\(hourReading)\(spokenMinute(minute))"
        }
    }
    
    private func spokenHour(_ h: Int) -> String {
        switch h {
        case 1: return "いちじ"
        case 2: return "にじ"
        case 3: return "さんじ"
        case 4: return "よじ"
        case 5: return "ごじ"
        case 6: return "ろくじ"
        case 7: return "しちじ"
        case 8: return "はちじ"
        case 9: return "くじ"
        case 10: return "じゅうじ"
        case 11: return "じゅういちじ"
        case 12: return "じゅうにじ"
        default: return "\(h)じ"
        }
    }
    
    private func spokenMinute(_ m: Int) -> String {
        switch m {
        case 1: return "いっぷん"
        case 2: return "にふん"
        case 3: return "さんぷん"
        case 4: return "よんぷん"
        case 5: return "ごふん"
        case 6: return "ろっぷん"
        case 7: return "ななふん"
        case 8: return "はっぷん"
        case 9: return "きゅうふん"
        case 10: return "じゅっぷん"
        case 11: return "じゅういっぷん"
        case 12: return "じゅうにふん"
        case 13: return "じゅうさんぷん"
        case 14: return "じゅうよんぷん"
        case 15: return "じゅうごふん"
        case 16: return "じゅうろっぷん"
        case 17: return "じゅうななふん"
        case 18: return "じゅうはっぷん"
        case 19: return "じゅうきゅうふん"
        case 20: return "にじゅっぷん"
        case 21: return "にじゅういっぷん"
        case 22: return "にじゅうにふん"
        case 23: return "にじゅうさんぷん"
        case 24: return "にじゅうよんぷん"
        case 25: return "にじゅうごふん"
        case 26: return "にじゅうろっぷん"
        case 27: return "にじゅうななふん"
        case 28: return "にじゅうはっぷん"
        case 29: return "にじゅうきゅうふん"
        case 30: return "さんじゅっぷん"
        case 31: return "さんじゅういっぷん"
        case 32: return "さんじゅうにふん"
        case 33: return "さんじゅうさんぷん"
        case 34: return "さんじゅうよんぷん"
        case 35: return "さんじゅうごふん"
        case 36: return "さんじゅうろっぷん"
        case 37: return "さんじゅうななふん"
        case 38: return "さんじゅうはっぷん"
        case 39: return "さんじゅうきゅうふん"
        case 40: return "よんじゅっぷん"
        case 41: return "よんじゅういっぷん"
        case 42: return "よんじゅうにふん"
        case 43: return "よんじゅうさんぷん"
        case 44: return "よんじゅうよんぷん"
        case 45: return "よんじゅうごふん"
        case 46: return "よんじゅうろっぷん"
        case 47: return "よんじゅうななふん"
        case 48: return "よんじゅうはっぷん"
        case 49: return "よんじゅうきゅうふん"
        case 50: return "ごじゅっぷん"
        case 51: return "ごじゅういっぷん"
        case 52: return "ごじゅうにふん"
        case 53: return "ごじゅうさんぷん"
        case 54: return "ごじゅうよんぷん"
        case 55: return "ごじゅうごふん"
        case 56: return "ごじゅうろっぷん"
        case 57: return "ごじゅうななふん"
        case 58: return "ごじゅうはっぷん"
        case 59: return "ごじゅうきゅうふん"
        default: return "\(m)ふん"
        }
    }
    
    // Check if times match within tolerance
    func matches(_ other: ClockTime, minuteTolerance: Int = 0) -> Bool {
        if minuteTolerance == 0 {
            return self.hour == other.hour && self.minute == other.minute
        }
        
        let selfTotal = (hour % 12) * 60 + minute
        let otherTotal = (other.hour % 12) * 60 + other.minute
        let diff = abs(selfTotal - otherTotal)
        return diff <= minuteTolerance || diff >= (12 * 60 - minuteTolerance)
    }
}

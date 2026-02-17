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
    
    // Japanese reading
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

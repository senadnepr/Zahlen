import Foundation

struct GeneratedItem: Equatable {
    let numericString: String // Visual representation (e.g., "42", "14:30", "21.03.2024")
    let targetText: String    // Target German text
    let type: ItemType
    
    enum ItemType: Equatable {
        case number(Int)
        case time(hour: Int, minute: Int)
        case date(day: Int, month: Int, year: Int)
    }
}

class NumberGenerator {
    private var alreadyUsedNumbers = Set<Int>()
    private var alreadyUsedTimes = Set<String>()
    private var alreadyUsedDates = Set<String>()
    
    func resetSession() {
        alreadyUsedNumbers.removeAll()
        alreadyUsedTimes.removeAll()
        alreadyUsedDates.removeAll()
    }
    
    func generate(for mode: NumberMode) -> GeneratedItem {
        switch mode {
        case .twoDigits:
            return generateNumber(in: 10...99)
        case .threeDigits:
            return generateNumber(in: 100...999)
        case .fourDigits:
            return generateNumber(in: 1000...9999)
        case .allNumbers:
            return generateNumber(in: 0...9999)
        case .time:
            return generateTime()
        case .dates:
            return generateDate()
        }
    }
    
    private func generateNumber(in range: ClosedRange<Int>) -> GeneratedItem {
        var randomInt = Int.random(in: range)
        
        // Anti-repetition check within session
        // If range is exhausted, it could infinite loop, but realistically ranges are large enough compared to typical sessions (max 50)
        var attempts = 0
        while alreadyUsedNumbers.contains(randomInt) && attempts < 100 {
            randomInt = Int.random(in: range)
            attempts += 1
        }
        alreadyUsedNumbers.insert(randomInt)
        
        let germanText = NumberToGermanConverter.shared.convert(number: randomInt)
        return GeneratedItem(
            numericString: "\(randomInt)",
            targetText: germanText,
            type: .number(randomInt)
        )
    }
    
    private func generateTime() -> GeneratedItem {
        var isInformal = Bool.random()
        var hour = Int.random(in: 0...23)
        var minute = isInformal ? (Int.random(in: 0...11) * 5) : Int.random(in: 0...59)
        
        var timeStr = String(format: "%02d:%02d", hour, minute)
        var uniquenessKey = "\(timeStr)_\(isInformal ? "informal" : "formal")"
        
        var attempts = 0
        while alreadyUsedTimes.contains(uniquenessKey) && attempts < 100 {
            isInformal = Bool.random()
            hour = Int.random(in: 0...23)
            minute = isInformal ? (Int.random(in: 0...11) * 5) : Int.random(in: 0...59)
            timeStr = String(format: "%02d:%02d", hour, minute)
            uniquenessKey = "\(timeStr)_\(isInformal ? "informal" : "formal")"
            attempts += 1
        }
        alreadyUsedTimes.insert(uniquenessKey)
        
        let style: NumberToGermanConverter.TimeStyle = isInformal ? .informal : .formal
        let germanText = NumberToGermanConverter.shared.convert(hour: hour, minute: minute, style: style)
        
        return GeneratedItem(
            numericString: timeStr,
            targetText: germanText,
            type: .time(hour: hour, minute: minute)
        )
    }
    
    private func generateDate() -> GeneratedItem {
        // Simple random date. Year from 1000 to 2099
        let year = Int.random(in: 1000...2099)
        let month = Int.random(in: 1...12)
        
        // Simplistic days in month logic
        let daysInMonth: Int
        switch month {
        case 2:
            let isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            daysInMonth = isLeap ? 29 : 28
        case 4, 6, 9, 11:
            daysInMonth = 30
        default:
            daysInMonth = 31
        }
        
        let day = Int.random(in: 1...daysInMonth)
        let dateStr = String(format: "%02d.%02d.%04d", day, month, year)
        
        if alreadyUsedDates.contains(dateStr) {
            // Keep it simple if collision happens
            return generateDate() 
        }
        alreadyUsedDates.insert(dateStr)
        
        let germanText = NumberToGermanConverter.shared.convert(day: day, month: month, year: year)
        return GeneratedItem(
            numericString: dateStr,
            targetText: germanText,
            type: .date(day: day, month: month, year: year)
        )
    }
}

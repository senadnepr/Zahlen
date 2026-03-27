import XCTest
@testable import Zahlen

final class TimeValidationTests: XCTestCase {
    func testCheckAnswerLogic() {
        let generator = NumberGenerator()
        // We know "viertel vor acht" maps to some number with minute = 45 and hour = 7 or 19.
        let item1 = GeneratedItem(numericString: "19:45", targetText: "viertel vor acht", type: .time(hour: 19, minute: 45))
        let item2 = GeneratedItem(numericString: "07:45", targetText: "viertel vor acht", type: .time(hour: 7, minute: 45))
        
        let checks = [
            ("19:45", "19:45", true),
            ("19:45", "07:45", true),
            ("19:45", "7:45", true),
            ("07:45", "19:45", true),
            ("07:45", "07:45", true),
            ("07:45", "7:45", true)
        ]
        
        for check in checks {
            let target = check.0
            let input = check.1
            let expected = check.2
            
            // Simulating checkAnswer logic
            let cleanedDigits = input
            let targetDigits = target
            var isCorrect = false
            
            var normalizedUserDigits = cleanedDigits
            var normalizedTargetDigits = targetDigits
            
            if cleanedDigits.contains(":") && targetDigits.contains(":") {
                if cleanedDigits.count == 4 && cleanedDigits.hasPrefix("0") == false {
                    normalizedUserDigits = "0\(cleanedDigits)"
                }
                if targetDigits.count == 4 && targetDigits.hasPrefix("0") == false {
                    normalizedTargetDigits = "0\(targetDigits)"
                }
                
                let targetParts = normalizedTargetDigits.split(separator: ":")
                let userParts = normalizedUserDigits.split(separator: ":")
                
                if targetParts.count == 2 && userParts.count == 2 {
                    if let targetHour = Int(targetParts[0]),
                       let userHour = Int(userParts[0]),
                       let targetMin = Int(targetParts[1]),
                       let userMin = Int(userParts[1]) {
                        
                        // Check if minutes match and hours differ exactly by 12 or match exactly modulo 12 when handling 0/12/24 logic
                        if targetMin == userMin {
                            let targetHour12 = targetHour % 12 == 0 ? 12 : targetHour % 12
                            let userHour12 = userHour % 12 == 0 ? 12 : userHour % 12
                            
                            if targetHour12 == userHour12 {
                                isCorrect = true
                            }
                        }
                    }
                }
            }
            
            if !isCorrect {
                if normalizedUserDigits == normalizedTargetDigits {
                    isCorrect = true
                } else if cleanedDigits == targetDigits {
                    isCorrect = true
                }
            }
            
            print("[\(target)] Input: \(input) -> Expected: \(expected), Got: \(isCorrect)")
        }
    }
}

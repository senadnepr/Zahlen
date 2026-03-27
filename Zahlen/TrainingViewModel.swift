import Foundation
import SwiftUI

enum ResultState {
    case none
    case correct
    case wrong
}

class TrainingViewModel: ObservableObject {
    @Published var currentItem: GeneratedItem?
    @Published var userInput: String = ""
    @Published var userDigitsInput: String = ""
    @Published var resultState: ResultState = .none
    
    enum InputPreference {
        case words
        case digits
    }
    @Published var inputPreference: InputPreference = .words
    
    let mode: NumberMode
    private let generator = NumberGenerator()
    let tasksPerSession: Int
    @Published var tasksCompleted = 0
    
    var isSessionComplete: Bool {
        tasksCompleted >= tasksPerSession
    }
    
    init(mode: NumberMode, tasksPerSession: Int) {
        self.mode = mode
        self.tasksPerSession = tasksPerSession
        generateNext()
    }
    
    func generateNext() {
        if isSessionComplete {
            return
        }
        userInput = ""
        userDigitsInput = ""
        resultState = .none
        currentItem = generator.generate(for: mode)
        speak()
    }
    
    func speak() {
        guard let germanText = currentItem?.targetText else { return }
        SpeechService.shared.speak(germanText)
    }
    
    func checkAnswer() {
        guard let currentItem = currentItem else { return }
        
        let cleanedWords = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanTarget = currentItem.targetText.lowercased()
        
        let cleanedDigits = userDigitsInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let targetDigits = currentItem.numericString
        
        var isCorrect = false
        
        if !cleanedWords.isEmpty {
            inputPreference = .words
            if cleanedWords == cleanTarget {
                isCorrect = true
            }
        } else if !cleanedDigits.isEmpty {
            inputPreference = .digits
            
            // Check if exact match first
            if cleanedDigits == targetDigits {
                isCorrect = true
            } else if cleanedDigits.contains(":") && targetDigits.contains(":") {
                // Time parser validation
                if let uParts = parseTime(cleanedDigits), let tParts = parseTime(targetDigits) {
                    if uParts.minute == tParts.minute {
                        if (uParts.hour % 12) == (tParts.hour % 12) {
                            isCorrect = true
                        }
                    }
                }
            }
        }
        
        if isCorrect {
            resultState = .correct
            tasksCompleted += 1
            triggerHaptic(success: true)
            
            // Auto advance
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.generateNext()
            }
        } else {
            resultState = .wrong
            triggerHaptic(success: false)
        }
    }
    
    // Helper to decompose time strings like "7:45", "07:45", "19:45"
    private func parseTime(_ timeStr: String) -> (hour: Int, minute: Int)? {
        let parts = timeStr.trimmingCharacters(in: .whitespaces).components(separatedBy: ":")
        guard parts.count == 2,
              let h = Int(parts[0]),
              let m = Int(parts[1]) else { return nil }
        return (h, m)
    }
    
    func repeatAudio() {
        speak()
    }
    
    func advance() {
        // Called when user clicks "Weiter" after incorrect
        tasksCompleted += 1
        generateNext()
    }
    
    private func triggerHaptic(success: Bool) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(success ? .success : .error)
    }
}

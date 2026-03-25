import Foundation
import AVFoundation

class SpeechService {
    static let shared = SpeechService()
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() {
        // Prepare synthesizer
    }
    
    func speak(_ text: String) {
        // Cancel any ongoing speech
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.0
        
        synthesizer.speak(utterance)
    }
}

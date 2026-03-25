import Foundation

enum NumberMode: String, CaseIterable, Identifiable {
    case twoDigits = "Zweistellige Zahlen"
    case threeDigits = "Dreistellige Zahlen"
    case fourDigits = "Vierstellige Zahlen"
    case allNumbers = "Alle Zahlen"
    case time = "Uhrzeit"
    case dates = "Daten"
    
    var id: String { self.rawValue }
}

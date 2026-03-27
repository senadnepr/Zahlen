import Foundation

class NumberToGermanConverter {
    static let shared = NumberToGermanConverter()
    
    // Core dictionaries
    private let units = ["", "ein", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun", "zehn", "elf", "zwölf", "dreizehn", "vierzehn", "fünfzehn", "sechzehn", "siebzehn", "achtzehn", "neunzehn"]
    private let tens = ["", "zehn", "zwanzig", "dreißig", "vierzig", "fünfzig", "sechzig", "siebzig", "achtzig", "neunzig"]
    
    private let months = ["", "Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
    
    func convert(number: Int) -> String {
        if number == 0 { return "null" }
        if number == 1 { return "eins" }
        return convertUnderTenThousand(number)
    }
    
    private func convertUnderTenThousand(_ n: Int) -> String {
        var result = ""
        var num = n
        
        if num >= 1000 {
            let thousands = num / 1000
            result += units[thousands] + "tausend"
            num %= 1000
        }
        
        if num >= 100 {
            let hundreds = num / 100
            result += units[hundreds] + "hundert"
            num %= 100
        }
        
        if num > 0 {
            if num < 20 {
                // Specialized case for 1: "eins" instead of "ein" when it's the final digit in a number <= 19
                // Actually, 101 is "einhunderteins", 1201 is "eintausendzweihunderteins".
                // But in `units`, 1 is "ein". Let's handle it.
                if num == 1 && n > 1 {
                    result += "eins"
                } else {
                    result += units[num]
                }
            } else {
                let unit = num % 10
                let ten = num / 10
                
                if unit > 0 {
                    result += units[unit] + "und" + tens[ten]
                } else {
                    result += tens[ten]
                }
            }
        }
        
        return result
    }
    
    enum TimeStyle {
        case formal
        case informal
    }
    
    func convert(hour: Int, minute: Int, style: TimeStyle = .formal) -> String {
        if style == .formal {
            let hourText = (hour == 1) ? "ein" : convert(number: hour)
            if minute == 0 {
                return "\(hourText) Uhr"
            }
            return "\(convert(number: hour)) Uhr \(convert(number: minute))"
        } else {
            let hour12 = hour % 12 == 0 ? 12 : hour % 12
            let nextHour12 = (hour + 1) % 12 == 0 ? 12 : (hour + 1) % 12
            
            let hourText = (hour12 == 1) ? "eins" : convert(number: hour12)
            let nextHourText = (nextHour12 == 1) ? "eins" : convert(number: nextHour12)
            
            switch minute {
            case 0:
                let hText = (hour12 == 1) ? "ein" : convert(number: hour12)
                return "\(hText) Uhr"
            case 5:   return "fünf nach \(hourText)"
            case 10:  return "zehn nach \(hourText)"
            case 15:  return "viertel nach \(hourText)"
            case 20:  return "zwanzig nach \(hourText)"
            case 25:  return "fünf vor halb \(nextHourText)"
            case 30:  return "halb \(nextHourText)"
            case 35:  return "fünf nach halb \(nextHourText)"
            case 40:  return "zwanzig vor \(nextHourText)"
            case 45:  return "viertel vor \(nextHourText)"
            case 50:  return "zehn vor \(nextHourText)"
            case 55:  return "fünf vor \(nextHourText)"
            default:
                return convert(hour: hour, minute: minute, style: .formal)
            }
        }
    }
    
    func convert(day: Int, month: Int, year: Int) -> String {
        // e.g., "einundzwanzigster" -> ends with "ster" if > 19, else "ter"
        let dayOrdinal: String
        if day < 20 {
            // 1st -> erster, 3rd -> dritter, 7th -> siebter, 8th -> achter
            switch day {
            case 1: dayOrdinal = "erster"
            case 3: dayOrdinal = "dritter"
            case 7: dayOrdinal = "siebter"
            case 8: dayOrdinal = "achter"
            default: dayOrdinal = convert(number: day) + "ter"
            }
        } else {
            dayOrdinal = convert(number: day) + "ster"
        }
        
        let monthText = months[month]
        
        // Year logic: Note that years like 1999 are "neunzehnhundertneunundneunzig"
        // 2000+ is "zweitausend..."
        let yearText: String
        if year >= 1100 && year < 2000 {
            let hundreds = year / 100
            let remainder = year % 100
            let remainderText = remainder > 0 ? convert(number: remainder) : ""
            yearText = convertUnderTenThousand(hundreds) + "hundert" + remainderText
        } else {
            yearText = convert(number: year)
        }
        
        return "\(dayOrdinal) \(monthText) \(yearText)"
    }
}

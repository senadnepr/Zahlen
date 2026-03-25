import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    @AppStorage("tasksPerSession") var tasksPerSession: Int = 10
}

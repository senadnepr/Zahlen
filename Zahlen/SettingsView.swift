import SwiftUI

struct SettingsView: View {
    @AppStorage("tasksPerSession") private var tasksPerSession: Int = 10
    
    var body: some View {
        Form {
            Section(header: Text("Anzahl der Aufgaben")) {
                Picker("Aufgaben pro Sitzung", selection: $tasksPerSession) {
                    Text("10").tag(10)
                    Text("20").tag(20)
                    Text("50").tag(50)
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Einstellungen")
    }
}

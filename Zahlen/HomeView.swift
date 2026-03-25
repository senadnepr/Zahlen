import SwiftUI

struct HomeView: View {
    let modes: [NumberMode] = NumberMode.allCases
    
    var body: some View {
        NavigationStack {
            List(modes) { mode in
                NavigationLink(value: mode) {
                    Text(mode.rawValue)
                        .font(.headline)
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("Zahlen")
            .navigationDestination(for: NumberMode.self) { mode in
                TrainingWrapperView(mode: mode)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

struct TrainingWrapperView: View {
    let mode: NumberMode
    @AppStorage("tasksPerSession") private var tasksPerSession = 10
    
    var body: some View {
        TrainingView(viewModel: TrainingViewModel(mode: mode, tasksPerSession: tasksPerSession))
    }
}

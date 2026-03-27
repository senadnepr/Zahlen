import SwiftUI

struct TrainingView: View {
    @StateObject var viewModel: TrainingViewModel
    
    enum Field {
        case words
        case digits
    }
    @FocusState private var focusedField: Field?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            
            if viewModel.isSessionComplete {
                VStack(spacing: 20) {
                    Text("Sitzung abgeschlossen!")
                        .font(.largeTitle)
                        .bold()
                    
                    Button("Zurück zum Menü") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                
                Button(action: {
                    viewModel.repeatAudio()
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding()
                        .background(Circle().fill(Color.blue.opacity(0.1)))
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    /*
                    TextField("Zahl als Wort eingeben", text: $viewModel.userInput)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .words)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        // Optional: keyboardType(.default) is standard for text
                        .onSubmit {
                            if !viewModel.userInput.trimmingCharacters(in: .whitespaces).isEmpty {
                                viewModel.checkAnswer()
                            }
                        }
                        .padding(.horizontal)
                        .disabled(viewModel.resultState != .none)
                        .onChange(of: viewModel.userInput) {
                            // If user types here, prioritize it
                            if !viewModel.userInput.isEmpty && viewModel.userDigitsInput.isEmpty {
                                viewModel.inputPreference = .words
                            }
                        }
                    */
                    
                    TextField("Oder als Ziffern eingeben (z.B. 42)", text: $viewModel.userDigitsInput)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .digits)
                        .keyboardType(.numbersAndPunctuation) // For digits, times, dates
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .onSubmit {
                            if !viewModel.userDigitsInput.trimmingCharacters(in: .whitespaces).isEmpty {
                                viewModel.checkAnswer()
                            }
                        }
                        .padding(.horizontal)
                        .disabled(viewModel.resultState != .none)
                        .onChange(of: viewModel.userDigitsInput) {
                            if !viewModel.userDigitsInput.isEmpty && viewModel.userInput.isEmpty {
                                viewModel.inputPreference = .digits
                            }
                        }
                }
                
                if viewModel.resultState == .none {
                    Button(action: {
                        viewModel.checkAnswer()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor((viewModel.userInput.trimmingCharacters(in: .whitespaces).isEmpty && viewModel.userDigitsInput.trimmingCharacters(in: .whitespaces).isEmpty) ? .gray : .green)
                    }
                    .disabled(viewModel.userInput.trimmingCharacters(in: .whitespaces).isEmpty && viewModel.userDigitsInput.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                
                if viewModel.resultState == .correct {
                    Text("Richtig!")
                        .font(.title)
                        .foregroundColor(.green)
                        .bold()
                } else if viewModel.resultState == .wrong {
                    VStack(spacing: 16) {
                        Text("Falsch!")
                            .font(.title)
                            .foregroundColor(.red)
                            .bold()
                        
                        // Text("Richtig: \(viewModel.currentItem?.targetText ?? "") (\(viewModel.currentItem?.numericString ?? ""))")
                        Text("Richtig: \(viewModel.currentItem?.targetText ?? "")")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            // .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            Button("Wiederholen") {
                                viewModel.userInput = ""
                                viewModel.userDigitsInput = ""
                                viewModel.resultState = .none
                                viewModel.repeatAudio()
                                // Added slight delay to ensure UI updates before refocusing
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedField = viewModel.inputPreference == .words ? .words : .digits
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Weiter") {
                                viewModel.advance()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedField = viewModel.inputPreference == .words ? .words : .digits
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .navigationTitle(viewModel.mode.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.isSessionComplete {
                    Text("\(min(viewModel.tasksCompleted + 1, viewModel.tasksPerSession))/\(viewModel.tasksPerSession)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .onAppear {
            focusedField = viewModel.inputPreference == .words ? .words : .digits
        }
        .onChange(of: viewModel.currentItem?.targetText) {
            if viewModel.resultState == .none {
                focusedField = viewModel.inputPreference == .words ? .words : .digits
            }
        }
    }
}

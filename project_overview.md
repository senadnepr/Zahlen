# Zahlen - iOS App

## Overview
Zahlen is an iOS app built with Swift and SwiftUI that helps users practice hearing and typing numbers, times, and dates in German. The app speaks a generated number, and the user must transcribe it via digits (e.g., "42") or German words (e.g., "zweiundvierzig").

## Architecture & Tech Stack
- **Platform:** iOS
- **UI Framework:** SwiftUI
- **Architecture Pattern:** MVVM (Model-View-ViewModel)

## Core Components
- **`ZahlenApp.swift` / `ContentView.swift`**: Application entry point, routing to `HomeView`.
- **`HomeView.swift`**: The main menu presenting training modes (`NumberMode`) and settings.
- **`TrainingView.swift` & `TrainingViewModel.swift`**: The core session screen and its logic. `TrainingViewModel` evaluates input, tracks session progress (`tasksPerSession`), and triggers success/error haptic feedback.
- **`NumberMode.swift`**: Enum defining the practice modes (two-digit, three-digit, four-digit, all numbers, time, dates).
- **`NumberGenerator.swift`**: Generates random targets based on the chosen mode while preventing immediate repetition within a session.
- **`NumberToGermanConverter.swift`**: Translates numeric values, times, and dates into correct German text.
- **`SpeechService.swift`**: Uses iOS speech synthesis to read the generated German text.
- **`SettingsView.swift` / `SettingsManager.swift`**: UI and `@AppStorage` helpers for user preferences.

## Application Flow
1. User picks a mode from `HomeView`, launching a `TrainingView`.
2. `NumberGenerator` produces a target (`GeneratedItem`), which includes the numeric value and the German translation from `NumberToGermanConverter`.
3. `SpeechService` reads the target aloud.
4. The user inputs their response via either a digits text field or a words text field.
5. The `TrainingViewModel` validates the user input against the expected string, showing "Richtig" (Correct) or "Falsch" (Wrong) and triggering haptic feedback. After completion, a session summary appears.

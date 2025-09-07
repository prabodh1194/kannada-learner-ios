import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var phraseService: PhraseService
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("ACCOUNT")) {
                    HStack {
                        Image(systemName: "person.circle")
                            .foregroundColor(.neonGreen)
                        Text("Profile")
                        Spacer()
                        Text("None")
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Section(header: Text("PREFERENCES")) {
                    HStack {
                        Image(systemName: "paintpalette")
                            .foregroundColor(.neonBlue)
                        Text("Theme")
                        Spacer()
                        Text("Dark Neon")
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.neonPink)
                        Text("Audio Playback")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                }
                
                Section(header: Text("DATA")) {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.neonPink)
                            Text("Reset All Progress")
                            Spacer()
                        }
                        .foregroundColor(.neonPink)
                    }
                    .alert("Reset All Progress", isPresented: $showingResetAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Reset", role: .destructive) {
                            resetProgress()
                        }
                    } message: {
                        Text("This will reset all your favorites and mastery levels. This action cannot be undone.")
                    }
                }
                
                Section(header: Text("ABOUT")) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.neonGreen)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.neonBlue)
                        Text("Contact Us")
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func resetProgress() {
        phraseService.loadSamplePhrases()
    }
}

#Preview {
    SettingsView()
        .environmentObject(PhraseService())
}
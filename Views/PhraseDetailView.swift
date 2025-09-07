import SwiftUI
import AVFoundation

struct PhraseDetailView: View {
    let phrase: Phrase
    @EnvironmentObject var phraseService: PhraseService
    @StateObject private var audioService = AudioService()
    @StateObject private var recordingService = RecordingService()
    @State private var isPlaying = false
    @State private var isRecording = false
    @State private var hasPermission = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Kannada text
                Text(phrase.kannadaText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.neonGreen)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // English translation
                VStack(alignment: .leading, spacing: 5) {
                    Text("Translation")
                        .font(.headline)
                        .foregroundColor(.neonBlue)
                    Text(phrase.englishTranslation)
                        .font(.body)
                        .foregroundColor(.textPrimary)
                }
                
                // Phonetic pronunciation
                VStack(alignment: .leading, spacing: 5) {
                    Text("Pronunciation")
                        .font(.headline)
                        .foregroundColor(.neonBlue)
                    Text(phrase.phoneticPronunciation)
                        .font(.body)
                        .italic()
                        .foregroundColor(.textSecondary)
                }
                
                // Category and difficulty
                HStack {
                    Text(phrase.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.neonBlue)
                        .foregroundColor(.darkBackground)
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    Text(phrase.difficulty.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(backgroundColorForDifficulty(phrase.difficulty))
                        .foregroundColor(.darkBackground)
                        .cornerRadius(12)
                }
                
                // Mastery level selector
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mastery Level")
                        .font(.headline)
                        .foregroundColor(.neonBlue)
                    
                    HStack {
                        ForEach(MasteryLevel.allCases, id: \.self) { level in
                            Button(action: {
                                var updatedPhrase = phrase
                                updatedPhrase.masteryLevel = level
                                phraseService.updatePhrase(updatedPhrase)
                            }) {
                                Text(level.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(level == phrase.masteryLevel ? backgroundColorForMasteryLevel(level) : Color.darkSurface)
                                    .foregroundColor(level == phrase.masteryLevel ? .darkBackground : .textPrimary)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(backgroundColorForMasteryLevel(level), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                
                // Audio playback section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pronunciation Practice")
                        .font(.headline)
                        .foregroundColor(.neonBlue)
                    
                    HStack {
                        Button(action: {
                            isPlaying.toggle()
                            if isPlaying {
                                audioService.playAudio(fileName: phrase.audioFileName)
                            } else {
                                audioService.stopAudio()
                            }
                        }) {
                            HStack {
                                Image(systemName: isPlaying ? "stop.circle" : "play.circle")
                                    .font(.title)
                                Text(isPlaying ? "Stop" : "Listen")
                            }
                            .padding()
                            .background(Color.neonGreen)
                            .foregroundColor(.darkBackground)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            if !isRecording {
                                Task {
                                    hasPermission = await recordingService.requestPermission()
                                    if hasPermission {
                                        isRecording = true
                                        recordingService.startRecording(fileName: "recording_\(phrase.id.uuidString).m4a")
                                    }
                                }
                            } else {
                                isRecording = false
                                recordingService.stopRecording()
                            }
                        }) {
                            HStack {
                                Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                                    .font(.title)
                                Text(isRecording ? "Stop" : "Record")
                            }
                            .padding()
                            .background(Color.neonPink)
                            .foregroundColor(.darkBackground)
                            .cornerRadius(12)
                        }
                    }
                }
                
                // Favorite button
                Button(action: {
                    phraseService.toggleFavorite(phrase)
                }) {
                    HStack {
                        Image(systemName: phrase.isFavorite ? "heart.fill" : "heart")
                        Text(phrase.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(phrase.isFavorite ? Color.neonPink : Color.darkSurface)
                    .foregroundColor(phrase.isFavorite ? .darkBackground : .neonPink)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.neonPink, lineWidth: 1)
                    )
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func backgroundColorForDifficulty(_ difficulty: DifficultyLevel) -> Color {
        switch difficulty {
        case .beginner:
            return .neonGreen
        case .intermediate:
            return .neonBlue
        case .advanced:
            return .neonPink
        }
    }
    
    private func backgroundColorForMasteryLevel(_ mastery: MasteryLevel) -> Color {
        switch mastery {
        case .new:
            return .neonPink
        case .learning:
            return .neonBlue
        case .mastered:
            return .neonGreen
        }
    }
}

#Preview {
    NavigationView {
        PhraseDetailView(phrase: SamplePhrases.all[0])
            .environmentObject(PhraseService())
    }
}
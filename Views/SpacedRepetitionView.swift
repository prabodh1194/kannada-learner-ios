import SwiftUI

struct SpacedRepetitionView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var currentPhrase: Phrase?
    @State private var showingResult = false
    @State private var qualityRating = 3
    
    var duePhrases: [Phrase] {
        phraseService.phrases.filter { $0.isDueForReview }
    }
    
    var body: some View {
        VStack {
            if let phrase = currentPhrase {
                // Phrase display
                VStack(spacing: 20) {
                    Text(phrase.kannadaText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                        .multilineTextAlignment(.center)
                    
                    if showingResult {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(phrase.englishTranslation)
                                .font(.title2)
                                .foregroundColor(.neonBlue)
                                .multilineTextAlignment(.center)
                            
                            Text(phrase.phoneticPronunciation)
                                .font(.body)
                                .italic()
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Action buttons
                VStack(spacing: 15) {
                    if !showingResult {
                        Button(action: {
                            showingResult = true
                        }) {
                            Text("Show Answer")
                                .font(.headline)
                                .foregroundColor(.darkBackground)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.neonGreen)
                                .cornerRadius(12)
                        }
                    } else {
                        VStack(spacing: 15) {
                            Text("How well did you know this?")
                                .font(.headline)
                                .foregroundColor(.neonBlue)
                            
                            // Quality rating buttons (0-5)
                            HStack(spacing: 10) {
                                ForEach(0..<6) { quality in
                                    Button(action: {
                                        ratePhrase(quality: quality)
                                    }) {
                                        Text("\(quality)")
                                            .font(.headline)
                                            .foregroundColor(.darkBackground)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(qualityColor(quality))
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            
                            // Quality descriptions
                            HStack {
                                Text("0\nForgot")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.center)
                                Spacer()
                                Text("5\nPerfect")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                // No phrases due for review
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.neonGreen)
                    
                    Text("All caught up!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                    
                    Text("No phrases are due for review right now.")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Check back later or practice some new phrases.")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            
            // Progress bar
            if !duePhrases.isEmpty {
                HStack {
                    Text("Reviewing: \\(duePhrases.count - (currentPhrase != nil ? 1 : 0)) left")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text("\\(phraseService.currentStreak) day streak")
                        .font(.caption)
                        .foregroundColor(.neonPink)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            loadNextPhrase()
        }
        .navigationTitle("Spaced Review")
    }
    
    private func loadNextPhrase() {
        guard !duePhrases.isEmpty else {
            currentPhrase = nil
            return
        }
        
        // Select a random phrase from the due phrases
        currentPhrase = duePhrases.randomElement()
        showingResult = false
        qualityRating = 3
    }
    
    private func ratePhrase(quality: Int) {
        guard let phrase = currentPhrase else { return }
        
        // Update the phrase's spaced repetition data
        var updatedPhrase = phrase
        updatedPhrase.updateSpacedRepetition(quality: quality)
        
        // Update mastery level based on quality
        if quality >= 4 {
            updatedPhrase.masteryLevel = .mastered
        } else if quality >= 2 {
            updatedPhrase.masteryLevel = .learning
        } else {
            updatedPhrase.masteryLevel = .new
        }
        
        // Save the updated phrase
        phraseService.updatePhrase(updatedPhrase)
        
        // Load the next phrase
        loadNextPhrase()
    }
    
    private func qualityColor(_ quality: Int) -> Color {
        switch quality {
        case 0, 1:
            return .neonPink // Poor quality
        case 2, 3:
            return .neonBlue // Fair quality
        case 4, 5:
            return .neonGreen // Good quality
        default:
            return .neonBlue
        }
    }
}

#Preview {
    NavigationView {
        SpacedRepetitionView(phraseService: PhraseService())
    }
}
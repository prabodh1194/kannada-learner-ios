import SwiftUI

struct PhraseRowView: View {
    let phrase: Phrase
    @EnvironmentObject var phraseService: PhraseService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(phrase.kannadaText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.neonGreen)
                
                Spacer()
                
                Button(action: {
                    phraseService.toggleFavorite(phrase)
                }) {
                    Image(systemName: phrase.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(phrase.isFavorite ? .neonPink : .textSecondary)
                }
            }
            
            Text(phrase.englishTranslation)
                .font(.body)
                .foregroundColor(.textPrimary)
            
            Text(phrase.phoneticPronunciation)
                .font(.caption)
                .italic()
                .foregroundColor(.textSecondary)
            
            HStack {
                Text(phrase.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.neonBlue)
                    .foregroundColor(.darkBackground)
                    .cornerRadius(8)
                
                Spacer()
                
                Text(phrase.difficulty.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(backgroundColorForDifficulty(phrase.difficulty))
                    .foregroundColor(.darkBackground)
                    .cornerRadius(8)
            }
            
            HStack {
                ForEach(MasteryLevel.allCases, id: \.self) { level in
                    Button(action: {
                        var updatedPhrase = phrase
                        updatedPhrase.masteryLevel = level
                        phraseService.updatePhrase(updatedPhrase)
                    }) {
                        Text(level.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(level == phrase.masteryLevel ? backgroundColorForMasteryLevel(level) : Color.darkSurface)
                            .foregroundColor(level == phrase.masteryLevel ? .darkBackground : .textPrimary)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(backgroundColorForMasteryLevel(level), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding()
        .background(Color.darkSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.neonGreen, lineWidth: 1)
        )
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
    PhraseRowView(phrase: SamplePhrases.all[0])
        .environmentObject(PhraseService())
}
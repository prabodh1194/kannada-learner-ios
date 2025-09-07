import SwiftUI

struct PhraseRowView: View {
    let phrase: Phrase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(phrase.kannadaText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.neonGreen)
            
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
}

#Preview {
    PhraseRowView(phrase: SamplePhrases.all[0])
}
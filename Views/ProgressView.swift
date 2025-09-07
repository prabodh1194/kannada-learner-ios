import SwiftUI

struct ProgressView: View {
    @ObservedObject var phraseService: PhraseService
    
    var totalPhrases: Int {
        phraseService.totalPhrases()
    }
    
    var masteredPhrases: Int {
        phraseService.masteredPhrases()
    }
    
    var learningPhrases: Int {
        phraseService.learningPhrases()
    }
    
    var newPhrases: Int {
        phraseService.newPhrases()
    }
    
    var favoritePhrases: Int {
        phraseService.favoritePhrasesCount()
    }
    
    var masteredPercentage: Double {
        totalPhrases > 0 ? Double(masteredPhrases) / Double(totalPhrases) * 100 : 0
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Streak display
                VStack(alignment: .leading, spacing: 10) {
                    Text("Daily Streak")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                    
                    HStack {
                        Image(systemName: "flame")
                            .foregroundColor(.neonPink)
                            .font(.title)
                        Text("\(phraseService.currentStreak) days")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.neonPink)
                        Spacer()
                    }
                    .padding()
                    .background(Color.darkSurface)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.neonPink, lineWidth: 1)
                    )
                }
                
                // Overall progress
                VStack(alignment: .leading, spacing: 10) {
                    Text("Overall Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                    
                    ProgressChartView(
                        total: totalPhrases,
                        mastered: masteredPhrases,
                        learning: learningPhrases,
                        new: newPhrases
                    )
                    
                    // Progress percentage
                    HStack {
                        Text("Mastered:")
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text("\(masteredPercentage, specifier: "%.1f")%")
                            .fontWeight(.bold)
                            .foregroundColor(.neonGreen)
                    }
                }
                
                // Stats
                VStack(alignment: .leading, spacing: 15) {
                    Text("Statistics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                    
                    StatCardView(
                        title: "Total Phrases",
                        value: totalPhrases,
                        color: .neonBlue
                    )
                    
                    StatCardView(
                        title: "Mastered",
                        value: masteredPhrases,
                        color: .neonGreen
                    )
                    
                    StatCardView(
                        title: "Learning",
                        value: learningPhrases,
                        color: .neonBlue
                    )
                    
                    StatCardView(
                        title: "New",
                        value: newPhrases,
                        color: .neonPink
                    )
                    
                    StatCardView(
                        title: "Favorites",
                        value: favoritePhrases,
                        color: .neonPink
                    )
                    
                    // Difficulty breakdown
                    Text("Phrases by Difficulty")
                        .font(.headline)
                        .foregroundColor(.neonBlue)
                        .padding(.top)
                    
                    StatCardView(
                        title: "Beginner",
                        value: phraseService.phrasesByDifficulty(.beginner),
                        color: .neonGreen
                    )
                    
                    StatCardView(
                        title: "Intermediate",
                        value: phraseService.phrasesByDifficulty(.intermediate),
                        color: .neonBlue
                    )
                    
                    StatCardView(
                        title: "Advanced",
                        value: phraseService.phrasesByDifficulty(.advanced),
                        color: .neonPink
                    )
                }
                
                // Mastery by category
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mastery by Category")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                    
                    ForEach(Category.allCases, id: \.self) { category in
                        CategoryProgressView(
                            category: category,
                            phrases: phraseService.phrases(for: category),
                            masteredCount: phraseService.masteredPhrasesByCategory(category),
                            learningCount: phraseService.learningPhrasesByCategory(category),
                            newCount: phraseService.newPhrasesByCategory(category)
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Progress")
    }
}

struct ProgressChartView: View {
    let total: Int
    let mastered: Int
    let learning: Int
    let new: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    if mastered > 0 {
                        Rectangle()
                            .fill(Color.neonGreen)
                            .frame(width: CGFloat(mastered) / CGFloat(total) * geometry.size.width)
                    }
                    
                    if learning > 0 {
                        Rectangle()
                            .fill(Color.neonBlue)
                            .frame(width: CGFloat(learning) / CGFloat(total) * geometry.size.width)
                    }
                    
                    if new > 0 {
                        Rectangle()
                            .fill(Color.neonPink)
                            .frame(width: CGFloat(new) / CGFloat(total) * geometry.size.width)
                    }
                }
            }
            .frame(height: 20)
            .cornerRadius(10)
            
            HStack {
                LegendItem(color: .neonGreen, text: "Mastered: \(mastered)")
                Spacer()
                LegendItem(color: .neonBlue, text: "Learning: \(learning)")
                Spacer()
                LegendItem(color: .neonPink, text: "New: \(new)")
            }
            .font(.caption)
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .foregroundColor(.textSecondary)
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.textPrimary)
            Spacer()
            Text("\(value)")
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .background(Color.darkSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color, lineWidth: 1)
        )
    }
}

struct CategoryProgressView: View {
    let category: Category
    let phrases: [Phrase]
    let masteredCount: Int
    let learningCount: Int
    let newCount: Int
    
    var totalCount: Int {
        phrases.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category.rawValue)
                .font(.headline)
                .foregroundColor(.neonBlue)
            
            if totalCount > 0 {
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        if masteredCount > 0 {
                            Rectangle()
                                .fill(Color.neonGreen)
                                .frame(width: CGFloat(masteredCount) / CGFloat(totalCount) * geometry.size.width)
                        }
                        
                        if learningCount > 0 {
                            Rectangle()
                                .fill(Color.neonBlue)
                                .frame(width: CGFloat(learningCount) / CGFloat(totalCount) * geometry.size.width)
                        }
                        
                        if newCount > 0 {
                            Rectangle()
                                .fill(Color.neonPink)
                                .frame(width: CGFloat(newCount) / CGFloat(totalCount) * geometry.size.width)
                        }
                    }
                }
                .frame(height: 15)
                .cornerRadius(7.5)
                
                HStack {
                    Text("Mastered: \(masteredCount)")
                        .font(.caption)
                        .foregroundColor(.neonGreen)
                    Spacer()
                    Text("Learning: \(learningCount)")
                        .font(.caption)
                        .foregroundColor(.neonBlue)
                    Spacer()
                    Text("New: \(newCount)")
                        .font(.caption)
                        .foregroundColor(.neonPink)
                }
                .font(.caption)
            } else {
                Text("No phrases")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .background(Color.darkSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.neonBlue, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        ProgressView(phraseService: PhraseService())
    }
}
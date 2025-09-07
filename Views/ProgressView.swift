import SwiftUI

struct ProgressView: View {
    @ObservedObject var phraseService: PhraseService
    
    var totalPhrases: Int {
        phraseService.phrases.count
    }
    
    var masteredPhrases: Int {
        phraseService.phrases.filter { $0.masteryLevel == .mastered }.count
    }
    
    var learningPhrases: Int {
        phraseService.phrases.filter { $0.masteryLevel == .learning }.count
    }
    
    var newPhrases: Int {
        phraseService.phrases.filter { $0.masteryLevel == .new }.count
    }
    
    var favoritePhrases: Int {
        phraseService.favoritePhrases().count
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                            phrases: phraseService.phrases(for: category)
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
    
    var masteredCount: Int {
        phrases.filter { $0.masteryLevel == .mastered }.count
    }
    
    var learningCount: Int {
        phrases.filter { $0.masteryLevel == .learning }.count
    }
    
    var newCount: Int {
        phrases.filter { $0.masteryLevel == .new }.count
    }
    
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
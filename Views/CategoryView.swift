import SwiftUI

struct CategoryView: View {
    let category: Category
    @ObservedObject var phraseService: PhraseService
    @State private var animationAmount: CGFloat = 1
    @State private var selectedMasteryLevel: MasteryLevel? = nil
    @State private var showingFilters = false
    
    var phrases: [Phrase] {
        let filteredByCategory = phraseService.phrases.filter { $0.category == category }
        
        if let masteryLevel = selectedMasteryLevel {
            return filteredByCategory.filter { $0.masteryLevel == masteryLevel }
        }
        
        return filteredByCategory
    }
    
    var body: some View {
        VStack {
            // Filter bar
            HStack {
                Text("Filter by:")
                    .foregroundColor(.textSecondary)
                
                Menu {
                    Button("All Levels", action: { selectedMasteryLevel = nil })
                    ForEach(MasteryLevel.allCases, id: \.self) { level in
                        Button(level.rawValue, action: { selectedMasteryLevel = level })
                    }
                } label: {
                    HStack {
                        Text(selectedMasteryLevel?.rawValue ?? "All Levels")
                            .foregroundColor(.neonGreen)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.neonGreen)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Phrases list
            List(phrases) { phrase in
                NavigationLink(destination: PhraseDetailView(phrase: phrase)) {
                    PhraseRowView(phrase: phrase)
                }
                .scaleEffect(animationAmount)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        animationAmount = 1.0
                    }
                }
            }
            .onAppear {
                animationAmount = 0.8
            }
        }
        .navigationTitle(category.rawValue)
    }
}

#Preview {
    NavigationView {
        CategoryView(category: .officeGreetings, phraseService: PhraseService())
    }
}
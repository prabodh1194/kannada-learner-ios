import SwiftUI

struct CategoryView: View {
    let category: Category
    @ObservedObject var phraseService: PhraseService
    
    var phrases: [Phrase] {
        phraseService.phrases.filter { $0.category == category }
    }
    
    var body: some View {
        List(phrases) { phrase in
            PhraseRowView(phrase: phrase)
        }
        .navigationTitle(category.rawValue)
    }
}

#Preview {
    CategoryView(category: .officeGreetings, phraseService: PhraseService())
}
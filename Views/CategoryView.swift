import SwiftUI

struct CategoryView: View {
    let category: Category
    @ObservedObject var phraseService: PhraseService
    @State private var animationAmount: CGFloat = 1
    
    var phrases: [Phrase] {
        phraseService.phrases.filter { $0.category == category }
    }
    
    var body: some View {
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
        .navigationTitle(category.rawValue)
    }
}

#Preview {
    NavigationView {
        CategoryView(category: .officeGreetings, phraseService: PhraseService())
    }
}
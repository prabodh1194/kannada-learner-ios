import SwiftUI

struct FavoritesView: View {
    @ObservedObject var phraseService: PhraseService
    
    var body: some View {
        List(phraseService.favoritePhrases()) { phrase in
            NavigationLink(destination: PhraseDetailView(phrase: phrase)) {
                PhraseRowView(phrase: phrase)
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationView {
        FavoritesView(phraseService: PhraseService())
    }
}
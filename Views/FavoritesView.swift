import SwiftUI

struct FavoritesView: View {
    @ObservedObject var phraseService: PhraseService
    
    var body: some View {
        List(phraseService.favoritePhrases()) { phrase in
            PhraseRowView(phrase: phrase)
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    FavoritesView(phraseService: PhraseService())
}
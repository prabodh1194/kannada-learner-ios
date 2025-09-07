import SwiftUI

struct SearchView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var searchText = ""
    
    var filteredPhrases: [Phrase] {
        if searchText.isEmpty {
            return phraseService.phrases
        } else {
            return phraseService.phrases.filter {
                $0.kannadaText.localizedCaseInsensitiveContains(searchText) ||
                $0.englishTranslation.localizedCaseInsensitiveContains(searchText) ||
                $0.phoneticPronunciation.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(filteredPhrases) { phrase in
            NavigationLink(destination: PhraseDetailView(phrase: phrase)) {
                PhraseRowView(phrase: phrase)
            }
        }
        .searchable(text: $searchText, prompt: "Search phrases...")
        .navigationTitle("Search")
    }
}

#Preview {
    NavigationView {
        SearchView(phraseService: PhraseService())
    }
}
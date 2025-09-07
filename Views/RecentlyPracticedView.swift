import SwiftUI

struct RecentlyPracticedView: View {
    @ObservedObject var phraseService: PhraseService
    
    var body: some View {
        List(phraseService.recentlyPracticedPhrases()) { phrase in
            NavigationLink(destination: PhraseDetailView(phrase: phrase)) {
                PhraseRowView(phrase: phrase)
            }
        }
        .navigationTitle("Recently Practiced")
    }
}

#Preview {
    NavigationView {
        RecentlyPracticedView(phraseService: PhraseService())
    }
}
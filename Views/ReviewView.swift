import SwiftUI

struct ReviewView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var reviewType: ReviewType = .needsReview
    
    var body: some View {
        VStack {
            // Segmented control for review type
            Picker("Review Type", selection: $reviewType) {
                Text("Needs Review").tag(ReviewType.needsReview)
                Text("Difficult").tag(ReviewType.difficult)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // List of phrases
            List {
                ForEach(reviewType == .needsReview ? 
                        phraseService.phrasesNeedingReview() : 
                        phraseService.difficultPhrases()) { phrase in
                    NavigationLink(destination: PhraseDetailView(phrase: phrase)) {
                        PhraseRowView(phrase: phrase)
                    }
                }
            }
        }
        .navigationTitle("Review")
    }
}

enum ReviewType {
    case needsReview
    case difficult
}

#Preview {
    NavigationView {
        ReviewView(phraseService: PhraseService())
    }
}
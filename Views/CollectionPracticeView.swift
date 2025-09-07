import SwiftUI

struct CollectionPracticeView: View {
    @EnvironmentObject var phraseService: PhraseService
    @State private var currentPhrase: Phrase?
    @State private var currentIndex = 0
    @State private var phrases: [Phrase] = []
    @State private var showingResult = false
    @State private var sessionStartDate: Date?
    @State private var sessionPhrasesPracticed = 0
    
    let collection: PhraseCollection
    
    var body: some View {
        VStack(spacing: 30) {
            if let phrase = currentPhrase {
                // Progress indicator
                HStack {
                    ForEach(0..<phrases.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.neonGreen : 
                                  index < currentIndex ? Color.neonBlue : 
                                  Color.darkSurface)
                            .frame(width: 10, height: 10)
                    }
                }
                
                // Collection info
                HStack {
                    Text(collection.name)
                        .font(.headline)
                        .foregroundColor(.neonGreen)
                    Spacer()
                    Text("\(sessionPhrasesPracticed)/\(phrases.count)")
                        .font(.headline)
                        .foregroundColor(.neonBlue)
                }
                .padding(.horizontal)
                
                // Phrase display
                VStack(spacing: 20) {
                    Text(phrase.kannadaText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                        .multilineTextAlignment(.center)
                    
                    if showingResult {
                        Text(phrase.englishTranslation)
                            .font(.title2)
                            .foregroundColor(.neonBlue)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Action buttons
                VStack(spacing: 15) {
                    if !showingResult {
                        Button(action: {
                            showingResult = true
                        }) {
                            Text("Show Answer")
                                .font(.headline)
                                .foregroundColor(.darkBackground)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.neonGreen)
                                .cornerRadius(12)
                        }
                    } else {
                        HStack(spacing: 15) {
                            Button(action: {
                                markPhrase(phrase, as: .new)
                                nextPhrase()
                            }) {
                                Text("Hard")
                                    .font(.headline)
                                    .foregroundColor(.darkBackground)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.neonPink)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                markPhrase(phrase, as: .learning)
                                nextPhrase()
                            }) {
                                Text("Good")
                                    .font(.headline)
                                    .foregroundColor(.darkBackground)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                .background(Color.neonBlue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                markPhrase(phrase, as: .mastered)
                                nextPhrase()
                            }) {
                                Text("Easy")
                                    .font(.headline)
                                    .foregroundColor(.darkBackground)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                .background(Color.neonGreen)
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No phrases available")
                    .font(.title)
                    .foregroundColor(.textSecondary)
            }
        }
        .onAppear {
            startPractice()
        }
        .onDisappear {
            endPracticeSession()
        }
    }
    
    private func startPractice() {
        // Start a new practice session
        sessionStartDate = Date()
        sessionPhrasesPracticed = 0
        
        // Get phrases from the collection
        phrases = phraseService.phrases(in: collection)
        
        // Shuffle the phrases
        phrases.shuffle()
        
        // Set the first phrase
        if !phrases.isEmpty {
            currentPhrase = phrases.first
        }
    }
    
    private func endPracticeSession() {
        guard let startDate = sessionStartDate else { return }
        
        let duration = Date().timeIntervalSince(startDate)
        
        // In a real app, you might want to save this session data
        print("Practice session ended. Duration: \(duration) seconds. Phrases practiced: \(sessionPhrasesPracticed)")
    }
    
    private func nextPhrase() {
        showingResult = false
        sessionPhrasesPracticed += 1
        
        if currentIndex < phrases.count - 1 {
            currentIndex += 1
            currentPhrase = phrases[currentIndex]
        } else {
            // Practice session completed
            endPracticeSession()
            startPractice()
            sessionPhrasesPracticed = 0
        }
    }
    
    private func markPhrase(_ phrase: Phrase, as masteryLevel: MasteryLevel) {
        var updatedPhrase = phrase
        updatedPhrase.masteryLevel = masteryLevel
        phraseService.updatePhrase(updatedPhrase)
    }
}

#Preview {
    CollectionPracticeView(collection: PhraseCollection(name: "Sample Collection", phraseIds: []))
        .environmentObject(PhraseService())
}
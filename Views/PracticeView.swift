import SwiftUI

struct PracticeView: View {
    @EnvironmentObject var phraseService: PhraseService
    @State private var currentPhrase: Phrase?
    @State private var currentIndex = 0
    @State private var phrases: [Phrase] = []
    @State private var showingResult = false
    @State private var isCorrect = false
    @State private var hasPracticedToday = false
    @State private var phrasesPracticed = 0
    
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
                
                // Streak and goal display
                HStack {
                    HStack {
                        Image(systemName: "flame")
                            .foregroundColor(.neonPink)
                        Text("Streak: \(phraseService.currentStreak) days")
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.neonGreen)
                        Text("Today: \(phrasesPracticed)/\(phraseService.dailyGoal)")
                            .fontWeight(.bold)
                    }
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
    }
    
    private func startPractice() {
        // Filter out mastered phrases for practice
        phrases = phraseService.phrases.filter { $0.masteryLevel != .mastered }
        
        // Shuffle the phrases
        phrases.shuffle()
        
        // Set the first phrase
        if !phrases.isEmpty {
            currentPhrase = phrases.first
        }
        
        // Update streak if not already done today
        if !hasPracticedToday {
            phraseService.updateStreak()
            hasPracticedToday = true
        }
    }
    
    private func nextPhrase() {
        showingResult = false
        phrasesPracticed += 1
        
        if currentIndex < phrases.count - 1 {
            currentIndex += 1
            currentPhrase = phrases[currentIndex]
        } else {
            // Practice session completed
            startPractice()
            phrasesPracticed = 0
        }
    }
    
    private func markPhrase(_ phrase: Phrase, as masteryLevel: MasteryLevel) {
        var updatedPhrase = phrase
        updatedPhrase.masteryLevel = masteryLevel
        phraseService.updatePhrase(updatedPhrase)
    }
}

#Preview {
    PracticeView()
        .environmentObject(PhraseService())
}
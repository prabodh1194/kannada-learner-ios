import SwiftUI

struct DailyGoalView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var goalText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var progress: Double {
        phraseService.goalProgress()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Daily Goal")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.neonGreen)
            
            // Progress ring
            ZStack {
                Circle()
                    .stroke(
                        Color.darkSurface,
                        lineWidth: 15
                    )
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        progress >= 1.0 ? Color.neonGreen : Color.neonBlue,
                        style: StrokeStyle(
                            lineWidth: 15,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int(progress * Double(phraseService.dailyGoal)))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                    Text("of \(phraseService.dailyGoal)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(width: 150, height: 150)
            
            Text("Phrases practiced today")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            // Set goal
            VStack(alignment: .leading, spacing: 10) {
                Text("Set Daily Goal")
                    .font(.headline)
                    .foregroundColor(.neonBlue)
                
                HStack {
                    TextField("Enter number of phrases", text: $goalText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    Button("Set") {
                        setGoal()
                    }
                    .padding()
                    .background(Color.neonGreen)
                    .foregroundColor(.darkBackground)
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.darkSurface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.neonBlue, lineWidth: 1)
            )
            
            // Motivational message
            Text(motivationalMessage())
                .font(.body)
                .italic()
                .foregroundColor(.neonPink)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            goalText = String(phraseService.dailyGoal)
        }
        .alert("Goal Updated", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func setGoal() {
        if let goal = Int(goalText), goal > 0 {
            phraseService.setDailyGoal(goal)
            alertMessage = "Daily goal set to \(goal) phrases!"
            showingAlert = true
        } else {
            alertMessage = "Please enter a valid number greater than 0."
            showingAlert = true
        }
    }
    
    private func motivationalMessage() -> String {
        let progress = phraseService.goalProgress()
        
        if progress >= 1.0 {
            return "🎉 Great job! You've reached your daily goal!"
        } else if progress >= 0.75 {
            return "💪 Almost there! Keep going!"
        } else if progress >= 0.5 {
            return "👍 You're making good progress!"
        } else if progress >= 0.25 {
            return "🌟 Keep practicing to reach your goal!"
        } else {
            return "🚀 Start practicing to reach your daily goal!"
        }
    }
}

#Preview {
    NavigationView {
        DailyGoalView(phraseService: PhraseService())
    }
}
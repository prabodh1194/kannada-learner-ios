import SwiftUI

struct LearningGoalsView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var showingAddGoal = false
    @State private var newGoalName = ""
    @State private var newGoalTarget = ""
    @State private var newGoalDeadline = Date()
    
    var body: some View {
        VStack {
            // Active goals
            if !phraseService.activeLearningGoals().isEmpty {
                SectionView(title: "Active Goals") {
                    ForEach(phraseService.activeLearningGoals()) { goal in
                        GoalRowView(goal: goal, phraseService: phraseService)
                    }
                }
            }
            
            // Completed goals
            if !phraseService.completedLearningGoals().isEmpty {
                SectionView(title: "Completed Goals") {
                    ForEach(phraseService.completedLearningGoals()) { goal in
                        GoalRowView(goal: goal, phraseService: phraseService)
                    }
                }
            }
            
            // Overdue goals
            if !phraseService.overdueLearningGoals().isEmpty {
                SectionView(title: "Overdue Goals") {
                    ForEach(phraseService.overdueLearningGoals()) { goal in
                        GoalRowView(goal: goal, phraseService: phraseService)
                    }
                }
            }
            
            Button(action: {
                showingAddGoal = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Goal")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.neonGreen)
                .foregroundColor(.darkBackground)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Learning Goals")
        .alert("Add Learning Goal", isPresented: $showingAddGoal) {
            VStack {
                TextField("Goal name", text: $newGoalName)
                TextField("Target mastered phrases", text: $newGoalTarget)
                    .keyboardType(.numberPad)
                DatePicker("Deadline", selection: $newGoalDeadline, displayedComponents: .date)
                
                HStack {
                    Button("Cancel", role: .cancel) { }
                    Button("Add") {
                        addGoal()
                    }
                }
            }
        }
    }
    
    private func addGoal() {
        if !newGoalName.isEmpty, 
           let target = Int(newGoalTarget),
           target > 0 {
            let goal = LearningGoal(name: newGoalName, target: target, deadline: newGoalDeadline)
            phraseService.addLearningGoal(goal)
            newGoalName = ""
            newGoalTarget = ""
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.neonGreen)
                .padding(.horizontal)
            
            content
        }
        .padding(.vertical)
    }
}

struct GoalRowView: View {
    @State var goal: LearningGoal
    @ObservedObject var phraseService: PhraseService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(goal.name)
                        .font(.headline)
                        .foregroundColor(.neonGreen)
                    
                    Text("\(goal.current)/\(goal.target) phrases mastered")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                if goal.completed {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.neonGreen)
                } else if goal.deadline < Date() {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.neonPink)
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.darkSurface)
                    
                    Rectangle()
                        .fill(goal.completed ? Color.neonGreen : Color.neonBlue)
                        .frame(width: CGFloat(goal.progressPercentage) / 100 * geometry.size.width)
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
            
            HStack {
                Text("\(Int(goal.progressPercentage))%")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Text("Due: \(dateFormatter.string(from: goal.deadline))")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .background(Color.darkSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(goal.completed ? Color.neonGreen : (goal.deadline < Date() ? Color.neonPink : Color.neonBlue), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

#Preview {
    NavigationView {
        LearningGoalsView(phraseService: PhraseService())
    }
}
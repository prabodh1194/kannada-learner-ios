import SwiftUI

struct HistoryView: View {
    @ObservedObject var phraseService: PhraseService
    
    var body: some View {
        List(phraseService.practiceHistory.reversed()) { session in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(dateFormatter.string(from: session.date))
                        .font(.headline)
                        .foregroundColor(.neonGreen)
                    Spacer()
                    Text(timeFormatter.string(from: session.date))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                HStack {
                    Text("Phrases: \(session.phrasesPracticed)")
                        .font(.subheadline)
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Text("Duration: \(durationFormatter.string(from: TimeInterval(session.duration)) ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.textPrimary)
                }
                
                // Mastery level breakdown
                HStack {
                    ForEach(MasteryLevel.allCases, id: \.self) { level in
                        if let count = session.masteryLevels[level.rawValue], count > 0 {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(colorForMasteryLevel(level))
                                    .frame(width: 8, height: 8)
                                Text("\(count)")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color.darkSurface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.neonBlue, lineWidth: 1)
            )
        }
        .navigationTitle("Practice History")
        .onAppear {
            // Refresh practice history when view appears
            phraseService.loadPracticeHistory()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private var durationFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }
    
    private func colorForMasteryLevel(_ level: MasteryLevel) -> Color {
        switch level {
        case .new:
            return .neonPink
        case .learning:
            return .neonBlue
        case .mastered:
            return .neonGreen
        }
    }
}

#Preview {
    NavigationView {
        HistoryView(phraseService: PhraseService())
    }
}
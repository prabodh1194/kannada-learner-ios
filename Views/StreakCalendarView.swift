import SwiftUI

struct StreakCalendarView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var currentDate = Date()
    
    var body: some View {
        VStack {
            // Month and year header
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.neonGreen)
                }
                
                Spacer()
                
                Text(monthYearFormatter.string(from: currentDate))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.neonGreen)
                
                Spacer()
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.neonGreen)
                }
            }
            .padding()
            
            // Day of week headers
            HStack {
                ForEach(dayOfWeekHeaders, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.neonBlue)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        CalendarDayView(date: date, isPracticeDay: isPracticeDay(date))
                    } else {
                        Color.clear
                    }
                }
            }
            .padding()
            
            // Legend
            HStack {
                HStack {
                    Circle()
                        .fill(Color.neonGreen)
                        .frame(width: 10, height: 10)
                    Text("Practice day")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                HStack {
                    Circle()
                        .fill(Color.darkSurface)
                        .frame(width: 10, height: 10)
                    Text("No practice")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding()
        }
        .navigationTitle("Practice Calendar")
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var dayOfWeekHeaders: [String] {
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let firstOfMonth = calendar.date(from: components) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstOfMonth)?.count ?? 0
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...daysInMonth {
            components.day = day
            if let date = calendar.date(from: components) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func isPracticeDay(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return phraseService.getPracticeDates().contains { practiceDate in
            calendar.isDate(date, inSameDayAs: practiceDate)
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isPracticeDay: Bool
    
    var body: some View {
        Text(dayFormatter.string(from: date))
            .font(.caption)
            .foregroundColor(isPracticeDay ? .darkBackground : .textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(isPracticeDay ? Color.neonGreen : Color.darkSurface)
            .cornerRadius(8)
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
}

#Preview {
    NavigationView {
        StreakCalendarView(phraseService: PhraseService())
    }
}
import SwiftUI

struct RemindersView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var showingAddReminder = false
    @State private var newReminderTime = Date()
    @State private var selectedDays: [Int] = []
    
    let daysOfWeek = [
        (0, "Sun"),
        (1, "Mon"),
        (2, "Tue"),
        (3, "Wed"),
        (4, "Thu"),
        (5, "Fri"),
        (6, "Sat")
    ]
    
    var body: some View {
        VStack {
            List {
                ForEach(phraseService.reminders) { reminder in
                    ReminderRowView(reminder: reminder, phraseService: phraseService)
                }
                .onDelete(perform: deleteReminders)
            }
            
            Button(action: {
                showingAddReminder = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Reminder")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.neonGreen)
                .foregroundColor(.darkBackground)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Reminders")
        .alert("Add Reminder", isPresented: $showingAddReminder) {
            VStack {
                DatePicker("Time", selection: $newReminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                
                HStack {
                    ForEach(daysOfWeek, id: \.0) { day in
                        DayToggle(day: day.1, isSelected: selectedDays.contains(day.0)) {
                            if selectedDays.contains(day.0) {
                                selectedDays.removeAll(where: { $0 == day.0 })
                            } else {
                                selectedDays.append(day.0)
                            }
                        }
                    }
                }
                
                HStack {
                    Button("Cancel", role: .cancel) { }
                    Button("Add") {
                        addReminder()
                    }
                }
            }
        }
    }
    
    private func addReminder() {
        if !selectedDays.isEmpty {
            let reminder = PracticeReminder(time: newReminderTime, days: selectedDays)
            phraseService.addReminder(reminder)
            selectedDays = []
        }
    }
    
    private func deleteReminders(offsets: IndexSet) {
        for index in offsets {
            phraseService.deleteReminder(phraseService.reminders[index])
        }
    }
}

struct ReminderRowView: View {
    @State var reminder: PracticeReminder
    @ObservedObject var phraseService: PhraseService
    
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(timeFormatter.string(from: reminder.time))
                        .font(.headline)
                        .foregroundColor(.neonGreen)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { reminder.enabled },
                        set: { newValue in
                            var updatedReminder = reminder
                            updatedReminder.toggleEnabled()
                            reminder = updatedReminder
                            phraseService.updateReminder(updatedReminder)
                        }
                    ))
                }
                
                Text(daysText)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.darkSurface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.neonBlue, lineWidth: 1)
            )
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private var daysText: String {
        if reminder.days.count == 7 {
            return "Every day"
        } else {
            return reminder.days.map { daysOfWeek[$0] }.joined(separator: ", ")
        }
    }
}

struct DayToggle: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.caption)
                .foregroundColor(isSelected ? .darkBackground : .textPrimary)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(isSelected ? Color.neonGreen : Color.darkSurface)
                .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationView {
        RemindersView(phraseService: PhraseService())
    }
}
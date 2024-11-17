import SwiftUI

struct GoalDetailView: View {
    @State var goal: Goal
    @ObservedObject var viewModel: GoalsViewModel
    @StateObject private var progressViewModel: ProgressViewModel
    @State private var showEditGoal = false
    @State private var showAddActivity = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var streakCount: Int = 0 // Placeholder for streak count

    init(goal: Goal, viewModel: GoalsViewModel) {
        self._goal = State(initialValue: goal)
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._progressViewModel = StateObject(wrappedValue: ProgressViewModel(goalId: goal.id!))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .center, spacing: 8) {
                    Text(goal.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color.purple)
                    
                    HStack(spacing: 16) {
                        Image(systemName: goal.iconName)
                            .foregroundColor(.yellow)
                            .font(.system(size: 32))
                        
                        VStack(alignment: .leading) {
                            Text("\(Int(goal.completionPercentage))%")
                                .font(.title2)
                                .bold()
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    ProgressView(value: goal.completionPercentage, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.black))
                        .frame(height: 8)
                        .padding(.horizontal)
                }

                // Milestones Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Milestones")
                        .font(.headline)
                    
                    ForEach(goal.milestones.indices, id: \.self) { index in
                        HStack {
                            Button(action: {
                                toggleMilestoneCompletion(index: index)
                            }) {
                                Image(systemName: goal.milestones[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(goal.milestones[index].isCompleted ? .green : .gray)
                            }
                            Text(goal.milestones[index].title)
                                .foregroundColor(.gray)
                        }
                    }
                }

                // Recent Activity Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Activity")
                        .font(.headline)
                    
                    ForEach(progressViewModel.progressEntries) { progress in
                        ActivityItem(label: progress.formattedDate, description: progress.description)
                    }
                }

                // Target Date and Streak
                HStack(spacing: 16) {
                    InfoCard(label: "Target Date", value: "\(goal.targetDate.formatted(.dateTime.day().month().year()))")
                    InfoCard(label: "Streak", value: "\(calculateStreak()) days")
                }

                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: completeGoal) {
                        Text("Complete Goal")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(goal.completionPercentage == 100.0) // Disable if goal is complete
                    
                    if goal.completionPercentage < 100.0 {
                        Button(action: { showAddActivity = true }) {
                            Text("Add Progress")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Goal Details")
        .sheet(isPresented: $showAddActivity) {
            AddActivityView(goalId: goal.id!, progressViewModel: progressViewModel)
        }
        .onAppear {
            updateCompletionPercentage()
        }
    }

    private func completeGoal() {
        goal.completionPercentage = 100.0
        viewModel.updateGoal(goal) { result in
            switch result {
            case .success:
                print("Goal marked as complete")
            case .failure(let error):
                print("Error completing goal: \(error)")
            }
        }
    }

    private func toggleMilestoneCompletion(index: Int) {
        goal.milestones[index].isCompleted.toggle()
        updateCompletionPercentage()
        viewModel.updateGoal(goal) { result in
            if case .failure(let error) = result {
                print("Error updating milestone completion: \(error)")
            }
        }
    }

    private func updateCompletionPercentage() {
        let completedMilestones = goal.milestones.filter { $0.isCompleted }.count
        goal.completionPercentage = Double(completedMilestones) / Double(goal.milestones.count) * 100
    }

    private func calculateStreak() -> Int {
        let dates = progressViewModel.progressEntries.map { $0.date }.sorted(by: >)
        var streak = 0
        var currentDate = Date()

        for date in dates {
            if Calendar.current.isDate(date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        return streak
    }
}

import SwiftUI

struct GoalDetailView: View {
    @Binding var goal: Goal
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var progressViewModel: ProgressViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddMilestone = false
    @State private var showEditMilestone = false
    @State private var selectedMilestoneIndex: Int? = nil
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    @State private var showAddActivityForMilestone: Milestone? = nil

    init(goal: Binding<Goal>) {
        self._goal = goal
        if let goalId = goal.wrappedValue.id {
            self._progressViewModel = StateObject(wrappedValue: ProgressViewModel(goalId: goalId))
        } else {
            self._progressViewModel = StateObject(wrappedValue: ProgressViewModel(goalId: "default_goal_id"))
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Goal Title and Progress Section
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
                    HStack {
                        Text("Milestones")
                            .font(.headline)
                        Spacer()
                        Button(action: { showAddMilestone = true }) {
                            Text("+ Add Milestone")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }

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
                                .onTapGesture {
                                    selectedMilestoneIndex = index
                                    showEditMilestone = true
                                }
                            Spacer()
                            Button(action: {
                                showAddActivityForMilestone = goal.milestones[index]
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.blue)
                            }
                            Button(action: {
                                deleteMilestone(index: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
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
                Button(action: completeGoal) {
                    Text("Complete Goal")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(goal.completionPercentage >= 100.0)

                // Direct Delete Button
                Button(action: deleteGoal) {
                    Text("Delete Goal")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            updateCompletionPercentage()
        }
        .sheet(isPresented: $showAddMilestone) {
            AddMilestoneView(goal: $goal, completion: { newMilestone in
                goal.milestones.append(newMilestone)
                updateCompletionPercentage()
            })
        }
        .sheet(isPresented: $showEditMilestone) {
            if let index = selectedMilestoneIndex {
                let milestoneBinding = Binding<Milestone>(
                    get: { goal.milestones[index] },
                    set: { goal.milestones[index] = $0 }
                )

                EditMilestoneView(
                    milestone: milestoneBinding,
                    onDelete: { deleteMilestone(index: index) },
                    onUpdate: { updateCompletionPercentage() }
                )
            }
        }
        .sheet(item: $showAddActivityForMilestone) { milestone in
            AddActivityView(goalId: goal.id ?? "", milestone: milestone, progressViewModel: progressViewModel)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Private Methods

    private func completeGoal() {
        goal.completionPercentage = 100.0
        updateGoal()
    }

    private func deleteGoal() {
        print("Attempting to delete goal...")
        goalsViewModel.deleteGoal(goal) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Goal deleted successfully. Dismissing view.")
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print("Failed to delete goal: \(error.localizedDescription)")
                    errorMessage = "Error deleting goal: \(error.localizedDescription)"
                    showErrorAlert = true
                }
            }
        }
    }

    private func deleteMilestone(index: Int) {
        goal.milestones.remove(at: index)
        updateCompletionPercentage()
    }

    private func toggleMilestoneCompletion(index: Int) {
        goal.milestones[index].isCompleted.toggle()
        updateCompletionPercentage()
    }

    private func updateCompletionPercentage() {
        let totalMilestones = goal.milestones.count
        guard totalMilestones > 0 else {
            goal.completionPercentage = 0.0
            updateGoal()
            return
        }
        let completedMilestones = goal.milestones.filter { $0.isCompleted }.count
        goal.completionPercentage = Double(completedMilestones) / Double(totalMilestones) * 100
        updateGoal()
    }

    private func updateGoal() {
        goalsViewModel.updateGoal(goal) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Goal updated successfully")
                case .failure(let error):
                    errorMessage = "Error updating goal: \(error.localizedDescription)"
                    showErrorAlert = true
                }
            }
        }
    }

    private func calculateStreak() -> Int {
        let sortedDates = progressViewModel.progressEntries.map { $0.date }.sorted(by: >)
        var streak = 0
        var currentDate = Date()
        let calendar = Calendar.current

        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: currentDate) {
                streak += 1
                guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                    break
                }
                currentDate = previousDate
            } else {
                break
            }
        }
        return streak
    }
}

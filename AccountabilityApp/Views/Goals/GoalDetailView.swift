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
                GoalHeaderView(
                    title: goal.title,
                    iconName: goal.iconName,
                    completionPercentage: goal.completionPercentage
                )

                // Milestones Section
                MilestonesView(
                    milestones: $goal.milestones,
                    selectedMilestoneIndex: $selectedMilestoneIndex,
                    showAddActivityForMilestone: $showAddActivityForMilestone,
                    progressEntries: progressViewModel.progressEntries, // Now [ProgressEntry]
                    toggleCompletion: toggleMilestoneCompletion,
                    deleteMilestone: deleteMilestone,
                    showAddMilestone: { showAddMilestone = true }
                )

                // Target Date and Streak
                InfoCardsView(
                    targetDate: "\(goal.targetDate.formatted(.dateTime.day().month().year()))",
                    streak: "\(calculateStreak()) days"
                )

                // Action Buttons
                ActionButtonsView(
                    completeGoal: completeGoal,
                    deleteGoal: deleteGoal,
                    isComplete: goal.completionPercentage >= 100.0
                )
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

//  EditGoalView.swift
import SwiftUI

struct EditGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var viewModel: GoalsViewModel // Use ObservedObject here
    
    @State var goal: Goal
    @State private var title: String
    @State private var description: String
    @State private var targetDate: Date

    init(goal: Goal, viewModel: GoalsViewModel) {
        self.viewModel = viewModel
        _goal = State(initialValue: goal)
        _title = State(initialValue: goal.title)
        _description = State(initialValue: goal.description)
        _targetDate = State(initialValue: goal.targetDate)
    }

    var body: some View {
        VStack(spacing: 16) {
            TextField("Title", text: $title)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            TextEditor(text: $description)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .frame(height: 150)

            DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            Button(action: saveChanges) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 16)

            Spacer()
        }
        .padding()
        .navigationTitle("Edit Goal")
    }

    private func saveChanges() {
        goal.title = title
        goal.description = description
        goal.targetDate = targetDate

        // Update the goal in Firebase
        viewModel.updateGoal(goal) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Error updating goal: \(error.localizedDescription)")
            }
        }
    }
}

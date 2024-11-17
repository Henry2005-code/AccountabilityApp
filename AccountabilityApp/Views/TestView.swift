//// TestView.swift
//import SwiftUI
//import FirebaseAuth
//
//struct TestView: View {
//    @EnvironmentObject var authViewModel: AuthenticationViewModel
//    @StateObject private var firebaseService = FirebaseService()
//    @State private var testGoalId: String?
//    @State private var fetchedGoals: [Goal] = []
//    @State private var errorMessage: String = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Firestore Testing")
//                .font(.title)
//
//            // Create a new goal
//            Button("Create Goal") {
//                createTestGoal()
//            }
//
//            // Fetch goals
//            Button("Fetch Goals") {
//                fetchUserGoals()
//            }
//
//            // Update the goal
//            if let goalId = testGoalId {
//                Button("Update Goal") {
//                    updateTestGoal(goalId: goalId)
//                }
//
//                Button("Delete Goal") {
//                    deleteTestGoal(goalId: goalId)
//                }
//            }
//
//            // Display fetched goals
//            List(fetchedGoals) { goal in
//                VStack(alignment: .leading) {
//                    Text(goal.title)
//                        .font(.headline)
//                    Text(goal.description)
//                        .font(.subheadline)
//                }
//            }
//
//            // Display error messages
//            if !errorMessage.isEmpty {
//                Text("Error: \(errorMessage)")
//                    .foregroundColor(.red)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            fetchUserGoals()
//        }
//    }
//
//    // MARK: - CRUD Functions
//
//    func createTestGoal() {
//        guard let userId = authViewModel.user?.uid else {
//            errorMessage = "User not authenticated."
//            return
//        }
//
//        let testGoal = Goal(
//            title: "Test Goal",
//            description: "This is a test goal.",
//            createdAt: Date(),
//            userId: userId
//        )
//
//        firebaseService.createGoal(testGoal) { result in
//            switch result {
//            case .success():
//                print("Goal created successfully.")
//                self.fetchUserGoals()
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//
//    func fetchUserGoals() {
//        guard let userId = authViewModel.user?.uid else {
//            errorMessage = "User not authenticated."
//            return
//        }
//
//        firebaseService.fetchGoals(for: userId) { result in
//            switch result {
//            case .success(let goals):
//                self.fetchedGoals = goals
//                if let firstGoal = goals.first {
//                    self.testGoalId = firstGoal.id
//                }
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//
//    func updateTestGoal(goalId: String) {
//        guard let index = fetchedGoals.firstIndex(where: { $0.id == goalId }) else {
//            errorMessage = "Goal not found."
//            return
//        }
//
//        var goalToUpdate = fetchedGoals[index]
//        goalToUpdate.title = "Updated Goal Title"
//
//        firebaseService.updateGoal(goalToUpdate) { result in
//            switch result {
//            case .success():
//                print("Goal updated successfully.")
//                self.fetchUserGoals()
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//
//    func deleteTestGoal(goalId: String) {
//        guard let index = fetchedGoals.firstIndex(where: { $0.id == goalId }) else {
//            errorMessage = "Goal not found."
//            return
//        }
//
//        let goalToDelete = fetchedGoals[index]
//
//        firebaseService.deleteGoal(goalToDelete) { result in
//            switch result {
//            case .success():
//                print("Goal deleted successfully.")
//                self.fetchUserGoals()
//                self.testGoalId = nil
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//}

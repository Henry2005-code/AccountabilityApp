import SwiftUI

struct GoalsListView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = GoalsViewModel()
    @State private var showCreateGoal = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.goals) { goal in
                        NavigationLink(destination: GoalDetailView(goal: goal, viewModel: viewModel)) {
                            GoalCardView(goal: goal)
                        }
                        .buttonStyle(PlainButtonStyle()) // To prevent NavigationLink styling
                    }
                }
                .padding()
            }
            .navigationTitle("My Goals")
            .toolbar {
                // Add Goal Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCreateGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                // Sign Out Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                if let userId = authViewModel.user?.uid {
                    viewModel.fetchGoals(userId: userId)
                } else {
                    print("User ID is nil")
                }
            }
            .sheet(isPresented: $showCreateGoal) {
                CreateGoalView()
                    .environmentObject(authViewModel)
            }
        }
    }

    // MARK: - Sign Out Function
    private func signOut() {
        do {
            try authViewModel.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

import SwiftUI

struct GoalsListView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @State private var showCreateGoal = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(goalsViewModel.goals.indices, id: \.self) { index in
                    NavigationLink {
                        GoalDetailView(goal: $goalsViewModel.goals[index])
                            .environmentObject(goalsViewModel)
                            .environmentObject(authViewModel)
                    } label: {
                        GoalCardView(goal: goalsViewModel.goals[index])
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("My Goals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showCreateGoal = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: signOut) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            goalsViewModel.fetchGoals()
        }
        .sheet(isPresented: $showCreateGoal) {
            CreateGoalView()
        }
    }

    private func signOut() {
        do {
            try authViewModel.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

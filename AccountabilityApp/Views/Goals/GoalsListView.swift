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
                Menu {
                    Button(action: viewProfile) {
                        Label("Profile", systemImage: "person.circle")
                    }
                    Button(action: viewSettings) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    Button(action: signOut) {
                        Label("Sign Out", systemImage: "arrow.backward.circle")
                            .foregroundColor(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle") // Use any appropriate icon
                        .font(.title2)
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

    private func viewProfile() {
        print("View Profile action")
    }

    private func viewSettings() {
        print("View Settings action")
    }
}

import Foundation
import FirebaseAuth
import FirebaseFirestore

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    private let firebaseService = FirebaseService()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchGoals() {
        // Remove previous listener if any
        listenerRegistration?.remove()
        
        // Fetch goals from FirebaseService
        listenerRegistration = firebaseService.fetchGoals { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let goals):
                    self?.goals = goals
                case .failure(let error):
                    print("Error fetching goals: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateGoal(_ goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        firebaseService.updateGoal(goal, completion: completion)
    }
    
    func deleteGoal(_ goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Deleting goal with title: \(goal.title) and ID: \(goal.id ?? "No ID")")
        firebaseService.deleteGoal(goal) { result in
            switch result {
            case .success:
                print("Successfully deleted goal.")
            case .failure(let error):
                print("Error in deleteGoal: \(error.localizedDescription)")
            }
            completion(result) // Propagate result back to caller
        }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}

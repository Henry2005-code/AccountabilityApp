// GoalsViewModel.swift
import Foundation
import FirebaseFirestore

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    private let firebaseService = FirebaseService()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchGoals(userId: String) {
        // Remove previous listener if any
        listenerRegistration?.remove()
        
        listenerRegistration = firebaseService.fetchGoals(for: userId) { [weak self] result in
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
    
    deinit {
        listenerRegistration?.remove()
    }
}

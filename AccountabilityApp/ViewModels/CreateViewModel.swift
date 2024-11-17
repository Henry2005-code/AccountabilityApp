// CreateGoalViewModel.swift
import Foundation

class CreateGoalViewModel: ObservableObject {
    private let firebaseService = FirebaseService()
    
    func createGoal(_ goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        firebaseService.createGoal(goal) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

import Foundation
import FirebaseFirestore

class FirebaseService: ObservableObject {
    private let db = Firestore.firestore()
    private let goalsCollection = "goals"

    // MARK: - Fetch all goals for the current user
    func fetchGoals(for userId: String, completion: @escaping (Result<[Goal], Error>) -> Void) -> ListenerRegistration {
        return db.collection(goalsCollection)
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let goals = snapshot?.documents.compactMap { document in
                        try? document.data(as: Goal.self)
                    } ?? []
                    completion(.success(goals))
                }
            }
    }

    // MARK: - Create a new goal
    func createGoal(_ goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            var newGoal = goal
            newGoal.createdAt = Date()
            _ = try db.collection(goalsCollection).addDocument(from: newGoal) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Update an existing goal
    func updateGoal(_ goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = goal.id else {
            completion(.failure(NSError(domain: "NoID", code: -1, userInfo: [NSLocalizedDescriptionKey: "Goal ID is missing."])))
            return
        }
        do {
            try db.collection(goalsCollection).document(id).setData(from: goal, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Delete a goal
    func deleteGoal(_ goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = goal.id else {
            completion(.failure(NSError(domain: "NoID", code: -1, userInfo: [NSLocalizedDescriptionKey: "Goal ID is missing."])))
            return
        }
        db.collection(goalsCollection).document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Update goal's completion percentage
    func updateGoalCompletion(goalId: String, increment: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(goalsCollection).document(goalId).updateData([
            "completionPercentage": FieldValue.increment(increment)
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

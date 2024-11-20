import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class FirebaseService: ObservableObject {
    private let db = Firestore.firestore()
    private let goalsCollection = "goals"
    private let progressCollection = "progress"

    // MARK: - Fetch all goals for the current user
    func fetchGoals(completion: @escaping (Result<[Goal], Error>) -> Void) -> ListenerRegistration? {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return nil
        }

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
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }

        var newGoal = goal
        newGoal.userId = userId // Attach userId to the goal
        newGoal.createdAt = Date()

        do {
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
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }

        db.collection(goalsCollection).document(goalId).updateData([
            "completionPercentage": FieldValue.increment(increment),
            "userId": userId // Ensure this update is tied to the authenticated user
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Fetch progress entries for a goal
    func fetchProgress(for goalId: String, completion: @escaping (Result<[Progress], Error>) -> Void) -> ListenerRegistration? {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return nil
        }

        return db.collection(progressCollection)
            .whereField("goalId", isEqualTo: goalId)
            .whereField("userId", isEqualTo: userId) // Filter by userId
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let progressEntries = snapshot?.documents.compactMap { document in
                        try? document.data(as: Progress.self)
                    } ?? []
                    completion(.success(progressEntries))
                }
            }
    }

    // MARK: - Add a progress entry
    func addProgress(_ progress: Progress, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }

        var newProgress = progress
        newProgress.userId = userId // Attach userId to the progress entry
        newProgress.date = Date()

        do {
            _ = try db.collection(progressCollection).addDocument(from: newProgress) { error in
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
}

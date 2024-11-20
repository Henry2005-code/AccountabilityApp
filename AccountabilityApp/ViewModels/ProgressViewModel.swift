import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class ProgressViewModel: ObservableObject {
    @Published var progressEntries: [ProgressEntry] = []
    private let firebaseService = FirebaseService()
    private var listenerRegistration: ListenerRegistration?
    private let goalId: String

    init(goalId: String) {
        self.goalId = goalId
        setupProgressListener()
    }
    
    private func setupProgressListener() {
        // Remove any existing listener
        listenerRegistration?.remove()
        
        // Get the current user's ID
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Setup real-time listener
        let db = Firestore.firestore()
        let query = db.collection("progress")
            .whereField("goalId", isEqualTo: goalId)
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
        
        listenerRegistration = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            guard let documents = snapshot?.documents else {
                print("Error fetching progress: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let fetchedProgress = documents.compactMap { document -> Progress? in
                try? document.data(as: Progress.self)
            }
            
            // Map [Progress] to [ProgressEntry]
            let mappedEntries = fetchedProgress.compactMap { $0.toProgressEntry() }
            
            DispatchQueue.main.async {
                self.progressEntries = mappedEntries
            }
        }
    }

    func addProgress(milestoneId: UUID, description: String, increment: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }

        let progress = Progress(id: nil, goalId: goalId, milestoneId: milestoneId, userId: userId, date: Date(), description: description)

        firebaseService.addProgress(progress) { [weak self] result in
            switch result {
            case .success:
                // The listener will automatically update the UI
                self?.firebaseService.updateGoalCompletion(goalId: self?.goalId ?? "", increment: increment) { updateResult in
                    DispatchQueue.main.async {
                        completion(updateResult)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    deinit {
        listenerRegistration?.remove()
    }
}

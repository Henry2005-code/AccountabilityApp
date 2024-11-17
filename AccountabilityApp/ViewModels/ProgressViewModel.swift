import Foundation
import FirebaseFirestore

class ProgressViewModel: ObservableObject {
    @Published var progressEntries: [Progress] = []
    private let db = Firestore.firestore()
    private let goalsCollection = "goals"
    
    // Reference to the specific goal document
    private var goalId: String
    
    init(goalId: String) {
        self.goalId = goalId
        fetchProgressEntries()
    }
    
    // Fetch all progress entries for the goal and listen for changes
    func fetchProgressEntries() {
        db.collection(goalsCollection).document(goalId).collection("progress")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching progress: \(error)")
                    return
                }
                
                self.progressEntries = snapshot?.documents.compactMap { document in
                    try? document.data(as: Progress.self)
                } ?? []
            }
    }
    
    // Add a new progress entry to Firestore and update goal's completion percentage
    func addProgress(description: String, increment: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        let newProgress = Progress(description: description, date: Date(), increment: increment)
        
        // Add the new progress entry to Firestore
        do {
            _ = try db.collection(goalsCollection).document(goalId).collection("progress").addDocument(from: newProgress) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // After successfully adding the progress entry, update the goal's completion percentage
                    self.updateGoalCompletion(by: increment, completion: completion)
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // Update goal's completion percentage in Firestore
    private func updateGoalCompletion(by increment: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        let goalRef = db.collection(goalsCollection).document(goalId)
        
        goalRef.updateData([
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

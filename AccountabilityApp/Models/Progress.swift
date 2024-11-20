import Foundation
import FirebaseFirestore

struct Progress: Identifiable, Codable {
    @DocumentID var id: String?
    var goalId: String
    var milestoneId: UUID // Ensure this is non-optional
    var userId: String
    var date: Date
    var description: String

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case goalId
        case milestoneId
        case userId
        case date
        case description
    }

    // Computed property to provide a non-optional unique identifier
    var uniqueID: String {
        id ?? UUID().uuidString
    }
}

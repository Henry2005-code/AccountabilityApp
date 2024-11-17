import Foundation
import FirebaseFirestore

struct Milestone: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct Goal: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var createdAt: Date
    var userId: String
    var iconName: String // The icon to represent this goal (e.g., "bolt.circle")
    var completionPercentage: Double // Completion percentage (0-100)
    var targetDate: Date // The date by which the goal should be completed
    var milestones: [Milestone] // Updated to use Milestone instead of String

    // Computed property to calculate days left until the target date
    var daysLeft: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: targetDate)
        return max(components.day ?? 0, 0) // Ensure no negative days
    }

    // CodingKeys for Firebase compatibility
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case createdAt
        case userId
        case iconName
        case completionPercentage
        case targetDate
        case milestones
    }
}

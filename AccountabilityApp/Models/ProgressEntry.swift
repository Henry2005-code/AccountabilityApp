import Foundation

struct ProgressEntry: Identifiable, Codable {
    let id: UUID
    let milestoneId: UUID
    let goalId: String
    let description: String
    let date: Date
    
    init(id: UUID = UUID(), milestoneId: UUID, goalId: String, description: String, date: Date = Date()) {
        self.id = id
        self.milestoneId = milestoneId
        self.goalId = goalId
        self.description = description
        self.date = date
    }
}

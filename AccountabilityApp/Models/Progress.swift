import FirebaseFirestore

struct Progress: Identifiable, Codable {
    @DocumentID var id: String?
    var goalId: String
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
        case userId
        case date
        case description
    }
}

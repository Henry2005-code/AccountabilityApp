import Foundation
import FirebaseFirestore

struct Progress: Identifiable, Codable {
    @DocumentID var id: String?
    var description: String
    var date: Date
    var increment: Double // Percentage increment for progress
    
    // Computed property to format date for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

import SwiftUI

struct MilestoneRowView: View {
    var milestone: Milestone
    @Binding var isExpanded: Bool
    var progressEntries: [ProgressEntry]
    var toggleCompletion: () -> Void
    var addActivity: () -> Void
    var deleteMilestone: () -> Void
    
    private var filteredEntries: [ProgressEntry] {
        progressEntries.filter { $0.milestoneId == milestone.id }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(alignment: .leading, spacing: 8) {
                    if filteredEntries.isEmpty {
                        Text("No activities recorded")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 16)
                    } else {
                        ForEach(filteredEntries.sorted(by: { $0.date > $1.date })) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.description)
                                    .font(.subheadline)
                                Text(dateFormatter.string(from: entry.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 16)
                        }
                    }
                    
                    HStack {
                        Button(action: addActivity) {
                            Label("Add Activity", systemImage: "plus")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button(action: deleteMilestone) {
                            Label("Delete Milestone", systemImage: "trash")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 8)
                }
            },
            label: {
                HStack {
                    Button(action: toggleCompletion) {
                        Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(milestone.isCompleted ? .green : .gray)
                    }
                    Text(milestone.title)
                        .strikethrough(milestone.isCompleted)
                        .foregroundColor(milestone.isCompleted ? .gray : .primary)
                    
                    if !filteredEntries.isEmpty {
                        Spacer()
                        Text("\(filteredEntries.count)")
                            .font(.caption)
                            .padding(4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        )
        .padding(.vertical, 8)
    }
}

// Preview provider for testing
struct MilestoneRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMilestone = Milestone(id: UUID(), title: "Sample Milestone", isCompleted: false)
        let sampleEntries = [
            ProgressEntry(milestoneId: sampleMilestone.id, goalId: "test", description: "First activity"),
            ProgressEntry(milestoneId: sampleMilestone.id, goalId: "test", description: "Second activity")
        ]
        
        return VStack {
            MilestoneRowView(
                milestone: sampleMilestone,
                isExpanded: .constant(true),
                progressEntries: sampleEntries,
                toggleCompletion: {},
                addActivity: {},
                deleteMilestone: {}
            )
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}

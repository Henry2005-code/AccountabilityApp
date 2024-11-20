import SwiftUI

struct MilestonesView: View {
    @Binding var milestones: [Milestone]
    @Binding var selectedMilestoneIndex: Int?
    @Binding var showAddActivityForMilestone: Milestone?
    var progressEntries: [ProgressEntry] // Now correctly typed as [ProgressEntry]
    var toggleCompletion: (Int) -> Void
    var deleteMilestone: (Int) -> Void
    var showAddMilestone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            ForEach(Array(milestones.enumerated()), id: \.offset) { (index, milestone) in
                let isExpanded = Binding<Bool>(
                    get: { selectedMilestoneIndex == index },
                    set: { newValue in
                        selectedMilestoneIndex = newValue ? index : nil
                    }
                )
                let filteredProgress = progressEntries.filter { $0.milestoneId == milestone.id }

                MilestoneRowView(
                    milestone: milestone,
                    isExpanded: isExpanded,
                    progressEntries: filteredProgress,
                    toggleCompletion: { toggleCompletion(index) },
                    addActivity: { showAddActivityForMilestone = milestone },
                    deleteMilestone: { deleteMilestone(index) }
                )
            }
        }
        .padding(.leading)
    }

    var header: some View {
        HStack {
            Text("Milestones")
                .font(.headline)
            Spacer()
            Button(action: showAddMilestone) {
                Text("+ Add Milestone")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
}

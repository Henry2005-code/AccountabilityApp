// AddMilestoneView.swift
import SwiftUI

struct AddMilestoneView: View {
    @Binding var goal: Goal
    var completion: (Milestone) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var milestoneTitle: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Milestone Title")) {
                    TextField("Enter title", text: $milestoneTitle)
                        .autocapitalization(.words)
                }
            }
            .navigationBarTitle("Add Milestone", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newMilestone = Milestone(title: milestoneTitle, isCompleted: false)
                    completion(newMilestone)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(milestoneTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            )
        }
    }
}

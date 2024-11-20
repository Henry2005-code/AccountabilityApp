// EditMilestoneView.swift
import SwiftUI

struct EditMilestoneView: View {
    @Binding var milestone: Milestone
    var onDelete: () -> Void
    var onUpdate: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var milestoneTitle: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Milestone Title")) {
                    TextField("Enter title", text: $milestoneTitle)
                        .autocapitalization(.words)
                        .onAppear {
                            self.milestoneTitle = milestone.title
                        }
                        .onChange(of: milestoneTitle) { newValue in
                            milestone.title = newValue
                            onUpdate()
                        }
                }
                
                Section {
                    Button(action: {
                        onDelete()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Delete Milestone")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Edit Milestone", displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

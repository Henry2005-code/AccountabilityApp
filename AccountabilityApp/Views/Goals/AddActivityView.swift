import SwiftUI

struct AddActivityView: View {
    var goalId: String
    @ObservedObject var progressViewModel: ProgressViewModel
    @State private var activityDescription: String = ""
    @State private var progressIncrement: Double = 0.0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Description")) {
                    TextField("Describe your activity", text: $activityDescription)
                }
                
                Section(header: Text("Progress Increment")) {
                    Slider(value: $progressIncrement, in: 0...20, step: 1)
                    Text("Progress: \(Int(progressIncrement))%")
                }
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveActivity()
                    }
                }
            }
        }
    }

    private func saveActivity() {
        progressViewModel.addProgress(description: activityDescription, increment: progressIncrement) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Error saving activity: \(error)")
            }
        }
    }
}

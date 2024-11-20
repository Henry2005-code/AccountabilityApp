import SwiftUI

struct AddActivityView: View {
    var goalId: String
    var milestone: Milestone // Changed from optional to non-optional
    @ObservedObject var progressViewModel: ProgressViewModel
    @State private var activityDescription: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Description")) {
                    TextField("Describe your activity", text: $activityDescription)
                        .disabled(isLoading)
                }
                
                Section(header: Text("Milestone")) {
                    Text("Adding activity for: \(milestone.title)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(isLoading)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !activityDescription.isEmpty {
                            isLoading = true
                            saveActivity()
                        }
                    }
                    .disabled(activityDescription.isEmpty || isLoading)
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.15))
                    }
                }
            )
        }
    }

    private func saveActivity() {
        let milestoneDescription = "\(activityDescription)"

        progressViewModel.addProgress(
            milestoneId: milestone.id,
            description: milestoneDescription,
            increment: 0
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                    print("Save Activity Error: \(error)")
                }
            }
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(
            goalId: "goal123",
            milestone: Milestone(title: "Milestone 1"),
            progressViewModel: ProgressViewModel(goalId: "goal123")
        )
    }
}

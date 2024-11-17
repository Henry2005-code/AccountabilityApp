import SwiftUI

struct CreateGoalView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CreateGoalViewModel()
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var targetDate: Date = Date()
    @State private var milestones: [Milestone] = [Milestone(title: "Milestone 1")]
    @State private var selectedIcon: String = "bolt.circle" // Default selected icon
    @State private var errorMessage: String = ""
    
    // Array of icon names
    let icons = ["bolt.circle", "target", "trophy", "laptopcomputer", "paintbrush", "heart", "star", "book", "lightbulb", "flame"]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    // Main Title with extra top padding
                    Text("Create Goal")
                        .font(.system(size: 32, weight: .bold, design: .rounded)) // Decorative font style
                        .foregroundColor(Color.purple)
                        .padding(.top, 40)

                    // Goal Title
                    TextField("Enter your goal", text: $title)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .frame(maxWidth: 300)

                    // Description
                    TextEditor(text: $description)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .frame(height: 120)
                        .frame(maxWidth: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )

                    // Icons Section in Grid Layout
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose an Icon")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                            ForEach(icons, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                }) {
                                    Image(systemName: icon)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding(8)
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle().stroke(Color.blue, lineWidth: selectedIcon == icon ? 2 : 0)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: 300)

                    // Target Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Date")
                            .font(.headline)
                        DatePicker("", selection: $targetDate, displayedComponents: .date)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .frame(maxWidth: 300)
                    }

                    // Milestones
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Milestones")
                            .font(.headline)
                        
                        ForEach(0..<milestones.count, id: \.self) { index in
                            HStack {
                                TextField("Milestone \(index + 1)", text: $milestones[index].title)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250)
                                Button(action: {
                                    milestones.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Button(action: {
                            milestones.append(Milestone(title: "New Milestone"))
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add Milestone")
                            }
                        }
                        .padding(.top, 8)
                        .foregroundColor(Color.blue)
                    }
                    .padding(.top, 8)
                    .frame(maxWidth: 300)

                    // Create Goal Button
                    Button(action: saveGoal) {
                        Text("Create Goal")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: 300)
                    .disabled(title.isEmpty)

                    // Error Message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    }

                    Spacer().frame(height: 40) // Extra space at the bottom
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: geometry.size.width) // Center content in the scroll view
                .frame(minHeight: geometry.size.height + 1) // Enforce scroll behavior
                .navigationBarTitle("Create Goal", displayMode: .inline)
            }
        }
    }
    
    // MARK: - Save Goal Function
    private func saveGoal() {
        guard let userId = authViewModel.user?.uid else {
            errorMessage = "User not authenticated."
            return
        }
        
        let newGoal = Goal(
            title: title,
            description: description,
            createdAt: Date(),
            userId: userId,
            iconName: selectedIcon,
            completionPercentage: 0.0, // Starting at 0% complete
            targetDate: targetDate,
            milestones: milestones // Pass in the array of Milestone objects
        )
        
        viewModel.createGoal(newGoal) { result in
            switch result {
            case .success():
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

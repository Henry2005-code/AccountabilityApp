//MainView.swift
import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: AuthenticationViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(viewModel.user?.email ?? "User")!")
                    .font(.largeTitle)
                    .padding()

                Button(action: {
                    do {
                        try viewModel.signOut()
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .navigationBarTitle("Accountability")
        }
    }
}

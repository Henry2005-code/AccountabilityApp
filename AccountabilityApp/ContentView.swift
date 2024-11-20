// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthenticationViewModel()
    @StateObject var goalsViewModel = GoalsViewModel()

    var body: some View {
        NavigationView {
            if authViewModel.user != nil {
                GoalsListView()
                    .environmentObject(goalsViewModel)
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
    }
}

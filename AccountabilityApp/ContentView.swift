// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthenticationViewModel()

    var body: some View {
        NavigationView {
            if authViewModel.user != nil {
                GoalsListView()
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

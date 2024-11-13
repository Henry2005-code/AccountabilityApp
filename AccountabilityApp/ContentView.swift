import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AuthenticationViewModel()

    var body: some View {
        Group {
            if viewModel.user != nil {
                MainView(viewModel: viewModel)
            } else {
                SignupView(viewModel: viewModel)
            }
        }
        .onAppear {
            self.viewModel.listenToAuthState()
        }
    }
}

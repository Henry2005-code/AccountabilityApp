// LoginView.swift
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            // Reduce top spacing
            Spacer().frame(height: 20)

            // Icon and Title
            VStack(spacing: 12) { // Reduced spacing between logo and text
                Image("Accountability")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Slightly smaller logo
                    .padding(.bottom, 8) // Reduced padding below the logo

                Text("Welcome Back")
                    .font(.system(size: 28, weight: .bold)) // Slightly larger and bold font
                    .foregroundColor(Color.purple)
                
                Text("Log in to continue your journey")
                    .font(.system(size: 16)) // Slightly smaller for balance
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            // Remove unnecessary Spacer and adjust spacing
            Spacer().frame(height: 12)

            // Email and Password Fields
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }

            // Login Button
            Button(action: {
                authViewModel.login(email: email, password: password) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Error Message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                    .padding(.top, 8)
            }

            // Divider with "or continue with" text
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Text("or continue with")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
            }.padding(.vertical, 16)

            // Google Sign-In Button
            Button(action: {
                authViewModel.signInWithGoogle { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }) {
                HStack {
                    Image("google-icon") // Ensure this image exists in your Assets.xcassets
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Google")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .medium))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            Spacer()

            // Navigation to Sign Up
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                NavigationLink(destination: SignupView()) {
                    Text("Sign up")
                        .foregroundColor(Color.purple)
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide the environment object for preview
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}

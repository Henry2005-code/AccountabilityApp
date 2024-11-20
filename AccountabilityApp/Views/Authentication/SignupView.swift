// SignupView.swift
import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)

            // Icon and Title
            VStack(spacing: 8) {
                Image("Accountability")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Larger size for better emphasis
                    .padding(.bottom, 8) // Add some padding below the logo for spacing
                
                Text("Create an Account")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.purple)
                
                Text("Join us on your journey to success")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }

            Spacer().frame(height: 20)

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

            // Sign Up Button
            Button(action: {
                authViewModel.signUp(email: email, password: password) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Sign Up")
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

            // Navigation to Log In
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                NavigationLink(destination: LoginView()) {
                    Text("Log in")
                        .foregroundColor(Color.purple)
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide the environment object for preview
        SignupView()
            .environmentObject(AuthenticationViewModel())
    }
}

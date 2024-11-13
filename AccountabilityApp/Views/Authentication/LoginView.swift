import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 40) // Top spacing
                
                // Icon and Title
                VStack(spacing: 8) {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.purple)
                    
                    Text("Welcome Back")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.purple)
                    
                    Text("Log in to continue your journey")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height: 20) // Spacing after title

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
                    viewModel.login(email: email, password: password) { error in
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
                // Google Sign-In Button
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.signInWithGoogle() { error in
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
                }

                
                Spacer()
                
                // Navigation to Sign Up
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink("Sign up", destination: SignupView(viewModel: viewModel))
                        .foregroundColor(Color.purple)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
        }
    }
}

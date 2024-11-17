import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {
    @Published var user: User?
        
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        listenToAuthState()
    }
    
    func listenToAuthState() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
        }
    }
    
    var isAuthenticated: Bool {
        return user != nil
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    func signInWithGoogle(completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            let error = NSError(domain: "NoClientID", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve client ID"])
            print(error.localizedDescription)
            completion(error)
            return
        }
        
        guard let presentingViewController = UIApplication.shared.getTopMostViewController() else {
            let error = NSError(domain: "NoPresentingViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to find the top view controller"])
            print(error.localizedDescription)
            completion(error)
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                let error = NSError(domain: "AuthenticationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication error"])
                print(error.localizedDescription)
                completion(error)
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Google Sign-In error: \(error.localizedDescription)")
                    completion(error)
                } else {
                    self?.user = authResult?.user
                    completion(nil)
                }
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.user = nil
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

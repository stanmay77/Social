// Auth firebase manager

import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    private init() { }
    
    // to check auth status for user
    var userLogged: String? {
        if let user = Auth.auth().currentUser {
            return user.email!
        } else {
            return nil
        }
    }
    
    
    // to log user in firebase
    func logUserIn(email: String, password: String, completion: @escaping (Result<Bool, AuthError>)->Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                switch error.localizedDescription {
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    completion(.failure(.userNotRegistered))
                case "The email address is badly formatted.":
                    completion(.failure(.emailBadlyFormatted))
                case "The password is invalid or the user does not have a password.":
                    completion(.failure(.invalidPassword))
                default:
                    completion(.failure(.otherError))
                }
            }
            
            guard let _ = result else {
                return
            }
            
            completion(.success(true))
        }
    }
    
    
    // to sign up user in firebase
    
    func signUpUser(with email: String, password: String, completion: @escaping (Result<Bool, SignUpError>)->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error {
                switch error.localizedDescription {
                case "The email address is badly formatted.":
                    completion(.failure(.signUpEmailBadlyFormatted))
                case "The email address is already in use by another account.":
                    completion(.failure(.signUpUserAlreadyExists))
                case "The password must be 6 characters long or more.":
                    completion(.failure(.passwordLengthIncorrect))
                default:
                    completion(.failure(.otherSignUpError))
                }
            }
            
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let _ = result else {
                return
            }
            
            completion(.success(true))
            
        }
        
    }
    
    // to log out user from firebase
    
    func logOut() {
        try? Auth.auth().signOut()
    }
    
}


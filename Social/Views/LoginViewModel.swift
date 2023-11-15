// View Model class to process log in in app

final class LogViewModel: LoginViewModel {
    
    var onStateChanged: ((State) -> Void)?
    
    enum State {
        case logged(RegisteredUser)
        case notlogged(AuthError?)
    }
    
    enum Input {
        case userCredentialsInput((String, String))
    }
    
    var state: State = .notlogged(nil) {
        didSet {
            onStateChanged!(state)
        }
    }
    
    //Current state update method
    
    func updateState(input: Input) {
        switch input {
        case .userCredentialsInput((let login, let password)):
            AuthManager.shared.logUserIn(email: login, password: password) { result in
                switch result {
                case .success:
                    // In case of successfull login getting user info and changing view model state
                    StorageManager.shared.getDocumentInfo(by: login) { (users: [RegisteredUser]) in
                        self.state = .logged(users[0])
                    }
                    
                case .failure(let error):
                    // Unsuccessfull login - changing view model state with particular error
                    self.state = .notlogged(error)
                }
            }
        }
    }
}

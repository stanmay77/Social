// FaceID manager

import LocalAuthentication

final class BiometryAuthManager {
    
    static let shared = BiometryAuthManager()
    
    private init() {}
    
    let manager = LAContext()
    
    
    // to check on whether user can use faceid
    var canUseBiometry: Bool {
        var error: NSError? = nil
        let canEvaluatePolicy = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error == nil && canEvaluatePolicy == true {
            return true
        } else {
            return false
        }
    }
    
    
    // to authorize user
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        
        var error: NSError? = nil
        let canEvaluatePolicy = manager.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error != nil {
            print(error!.localizedDescription)
        }
        
        guard canEvaluatePolicy else { return }
        
        manager.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Reason") { result, error in
            if result {
                authorizationFinished(true)
            } else {
                authorizationFinished(false)
            }
        }
    }
    
}

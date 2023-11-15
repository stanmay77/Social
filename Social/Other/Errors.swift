import Foundation

enum AuthError: String, Error {
    case invalidPassword = "authInvalidPassword"
    case emailBadlyFormatted = "emailBadlyFormatted"
    case userNotRegistered = "authUserNotRegistered"
    case otherError = "authOtherError"
    
    var localizedAuthError: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
}

enum SignUpError: String, Error {
    case signUpEmailBadlyFormatted = "signUpEmailBadlyFormatted"
    case signUpUserAlreadyExists = "signUpUserAlreadyExists"
    case otherSignUpError = "otherSignUpError"
    case passwordLengthIncorrect = "passwordLengthIncorrect"
    
    var localizedSignUpError: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum CloudError: String, Error {
    case connectionError = "cloudConnectionError"
    
    var localizedSignUpError: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

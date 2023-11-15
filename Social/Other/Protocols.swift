import MapKit

protocol LoginViewModel {
    var onStateChanged: ((LogViewModel.State)->Void)? { get set }
    func updateState(input: LogViewModel.Input)
}

protocol ProfileButtonsDelegate: AnyObject {
    func didTapNewPost(for user: RegisteredUser)
    func didTapPhotos(for user: RegisteredUser)
    func didTapLocations(for user: RegisteredUser)
    func didTapEditUser(for user: RegisteredUser)
}

protocol AddFollowerDelegate: AnyObject {
    func addFollowedUser()
    func viewFollowedUser(for follower: RegisteredUser)
}

protocol NewPostDelegate: AnyObject {
    func updateCurrentUser(using user: RegisteredUser)
}

protocol EditUserProtocol: AnyObject {
    func updateCurrentUser(using user: RegisteredUser)
}

protocol UpdatePhotoGalleryDelegate: AnyObject {
    func updatePhotoGallery(for user: RegisteredUser)
}

protocol MapTypeOptionDelegateProtocol: AnyObject {
    func didSelectMapType(_ type: MKMapType)
}

protocol NewFollowedDelegate: AnyObject {
    func changeFollowedUsers(for user: RegisteredUser, remove: Bool, with followed: RegisteredUser)
}



// Data model for user in Social

struct RegisteredUser: Codable {
    //@DocumentID var id: String? = UUID().uuidString
    let login: String
    var fullName: String
    let avatarURL: String?
    var city: String
    var occupation: String
    var posts: Int
    let subscriptions: Int
    let followers: Int
    var followedBy: [String]
    var meFollowing: [String]
    var userPhotos: [String]
    
    init(login: String, fullName: String, avatarURL: String?, city: String, occupation: String, posts: Int, subscriptions: Int, followers: Int, followedBy: [String], meFollowing: [String], userPhotos: [String]) {
        self.login = login
        self.fullName = fullName
        self.avatarURL = avatarURL
        self.city = city
        self.occupation = occupation
        self.posts = posts
        self.subscriptions = subscriptions
        self.followers = followers
        self.followedBy = followedBy
        self.meFollowing = meFollowing
        self.userPhotos = userPhotos
    }
}

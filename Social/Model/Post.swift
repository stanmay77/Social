import Foundation
import FirebaseFirestoreSwift



// Data model for post in Social

struct Post: Codable, Equatable {
    
    @DocumentID var id: String?
    let postTitle: String
    let postDate: Date
    let postImage: String
    let postText: String
    var likes: Int
    var likesByUser: [String]
    let author: String
    var isFavoritePost: Bool
    
    init(postTitle: String, postDate: Date, postImage: String, postText: String, likes: Int, likesByUser: [String], author: String, isFavoritePost: Bool) {
        self.postTitle = postTitle
        self.postDate = postDate
        self.postImage = postImage
        self.postText = postText
        self.likes = likes
        self.likesByUser = likesByUser
        self.author = author
        self.isFavoritePost = isFavoritePost
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.postTitle == rhs.postTitle &&
               lhs.postDate == rhs.postDate &&
               lhs.postImage == rhs.postImage &&
               lhs.postText == rhs.postText &&
               lhs.likes == rhs.likes &&
               lhs.likesByUser == rhs.likesByUser &&
               lhs.author == rhs.author &&
               lhs.isFavoritePost == rhs.isFavoritePost
               
    }
    
    
    
}

import UIKit
import CoreData

extension UITextField {
    
    func setSpacer(for space: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.size.width))
        self.leftViewMode = .always
    }
    
}

extension UIColor {
    static func createColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return light
        }
        
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? light : dark
        }
    }
    
    
    static let fieldColor1 = createColor(light: UIColor(named: "orangeTFColor")!, dark: .white)
    static let buttonColor = createColor(light: .black, dark: UIColor(named: "orangeTFColor")!)
    static let postColor = createColor(light: .white, dark: .systemGray6)
    static let fieldColor2 = createColor(light: .systemGray4, dark: .systemGray)
    static let navBarColor = createColor(light: UIColor(named: "AccentColor")!, dark: .systemGray4)
    static let tabBarColor = createColor(light: UIColor(named: "AccentColor")!, dark: .white)
    static let faceIdColor = createColor(light: UIColor(named: "AccentColor")!, dark: .white)
}

extension CDPost {
    func toStruct() -> Post {
        
        var likesUserIds: [String] = []

                // Safely unwrap likesByUsers and cast each element
                if let likesSet = self.likesByUser as? Set<CDLikesByUser> {
                    likesUserIds = likesSet.compactMap { $0.userID } // Assuming userID is non-optional
                }


        return Post(postTitle: self.postTitle!, postDate: self.postDate!, postImage: self.postImage!, postText: self.postText!, likes: Int(self.likes), likesByUser: likesUserIds, author: self.author!, isFavoritePost: self.isFavoritePost)

    }
}

extension Post {
    func toCDPost(context: NSManagedObjectContext) -> CDPost {
        let cdPost = CDPost(context: context)
        updateCDPost(cdPost, context: context)
        return cdPost
    }

    func updateCDPost(_ cdPost: CDPost, context: NSManagedObjectContext) {
        cdPost.postTitle = self.postTitle
        cdPost.postDate = self.postDate
        cdPost.postImage = self.postImage
        cdPost.postText = self.postText
        cdPost.likes = Int32(self.likes)
        cdPost.author = self.author
        cdPost.isFavoritePost = self.isFavoritePost

        // Manage likesByUser relationship
        updateLikesByUser(for: cdPost, context: context)
    }

    private func updateLikesByUser(for cdPost: CDPost, context: NSManagedObjectContext) {
        // First, clear the existing likes to avoid duplicates
        if let existingLikes = cdPost.likesByUser as? Set<CDLikesByUser> {
            existingLikes.forEach { context.delete($0) }
        }

        // Add new likes
        self.likesByUser.forEach { userID in
            let like = CDLikesByUser(context: context)
            like.userID = userID
            cdPost.addToLikesByUser(like)
        }
    }
}


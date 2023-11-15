// Firebase storage manager

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


// code collectionRef in Firebase
enum StorageCollection {
    case object(type: Any.Type)

    var collectionRef: String {
        switch self {
        case .object(let type):
            if type == RegisteredUser.self {
                return "Users"
            } else if type == Post.self {
                return "Posts"
            } else if type == Location.self {
                return "Locations"
            }
            else {
                fatalError("Unsupported type")
            }
        }
    }
    
    var searchString: String {
        switch self {
        case .object(type: let type):
            if type == RegisteredUser.self {
                return "login"
            } else if type == Post.self {
                return "author"
            } else if type == Location.self {
                return "user"
            } else {
                fatalError("Unsupported type")
            }
        }
    }
}


final class StorageManager {
    
    let db = Firestore.firestore()
    static let shared = StorageManager()
    private init() {}

    // to save user in firebase
    func saveUserToDB(user: RegisteredUser) {
        
        let collectionRef = db.collection("Users")
        do {
            let _ = try collectionRef.addDocument(from: user)
        }
        catch {
            print(error.localizedDescription)
        }
    }
  
    // to get user from firebase
    func getUser(by login: String, completion: @escaping (RegisteredUser) -> Void) {
        
        let collectionRef = db.collection("Users")
        
        let query = collectionRef.whereField("login", isEqualTo: login)
        
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        let user = try document.data(as: RegisteredUser.self)
                        completion(user)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    // to fetch document of general type
    func getDocumentInfo<T:Codable>(by stringAttribute: String?, completion: @escaping ([T]) -> Void) {
        
        //var collectionRef: CollectionReference? = nil
        var queryArray: [T] = []
        
        let collectionRef = db.collection(StorageCollection.object(type: T.self).collectionRef)
        
        var query: Query
        
        if stringAttribute != nil {
            query = collectionRef.whereField(StorageCollection.object(type: T.self).searchString, isEqualTo: stringAttribute!)
        } else {
            query = collectionRef
        }
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        let doc = try document.data(as: T.self)
                        queryArray.append(doc)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                completion(queryArray)
            }
        }
    }
    
    // to save document of general type
    func saveDocumentInfo<T:Codable>(for object: T, completion: @escaping (Bool)->Void) {
        
        //var collectionRef: CollectionReference? = nil
        
        let collectionRef = db.collection(StorageCollection.object(type: T.self).collectionRef)
        
        do {
            let _ = try collectionRef.addDocument(from: object)
            completion(true)
        }
        catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    // to update custom fields in general type doc
    func updateDocument<T:Codable>(by stringAttribute: String, fields: [String: Any], completion: @escaping ([T]) -> Void) {
        
        let collectionRef = db.collection(StorageCollection.object(type: T.self).collectionRef)
        let query = collectionRef.whereField(StorageCollection.object(type: T.self).searchString, isEqualTo: stringAttribute)
        
        query.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.updateData(fields) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    // to delete doc from firebase
    func deleteDocument<T: Codable>(_ type: T.Type, by docID: String, completion: @escaping (Bool) -> Void) {
        
        let collectionRef = db.collection(StorageCollection.object(type: T.self).collectionRef)
        let documentRef = collectionRef.document(docID)
        
        documentRef.delete() { error in
            if let error = error {
                print("Error deleting document: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
        
    }
    
    // convinience method to update user post number
    func updateUserPostNumber(for user: RegisteredUser, number: Int) {
        self.getUser(by: user.login) { userDB in
            
            let newUserPosts = userDB.posts + number
            
            StorageManager.shared.updateDocument(by: userDB.login, fields: ["posts": newUserPosts]) {
                (user: [RegisteredUser]) in
            }
        }
    }
    
    
    // convenience method to get followers
    func getFollowedUsers(for user: RegisteredUser, completion: @escaping ([RegisteredUser])->Void) {
        var followedUsers: [RegisteredUser] = []
        
        getUser(by: user.login) { user in
            let followedLogins = user.meFollowing
            let group = DispatchGroup()
            for login in followedLogins {
                group.enter()
                self.getUser(by: login) { user in
                    followedUsers.append(user)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(followedUsers)
            }
        }
    }
    
    // convinience method to save new follower
    func saveFollower(for user: RegisteredUser, follower: RegisteredUser) {
        self.getUser(by: user.login) { userDB in
            
            var alreadyFollowed = userDB.meFollowing
            alreadyFollowed.append(follower.login)
            
            var subscribed = userDB.subscriptions
            subscribed += 1
            
            self.getUser(by: follower.login) { follower in
                var followedBy = follower.followers
                followedBy += 1
                
                var followedArray = follower.followedBy
                followedArray.append(user.login)
                
                StorageManager.shared.updateDocument(by: follower.login, fields: ["followedBy": followedArray, "followers": followedBy]) {
                    (user: [RegisteredUser]) in
                }
                
            }
            StorageManager.shared.updateDocument(by: userDB.login, fields: ["meFollowing": alreadyFollowed, "subscriptions": subscribed]) {
                (user: [RegisteredUser]) in
            }
            
        }
    }
    
    
    // convinience method to delete follower
    func deleteFollower(for user: RegisteredUser, follower: RegisteredUser) {
        self.getUser(by: user.login) { userDB in
            
            var alreadyFollowed = userDB.meFollowing
            alreadyFollowed.removeAll(where: {$0 == follower.login})
            
            var subscribed = userDB.subscriptions
            subscribed -= 1
            
            self.getUser(by: follower.login) { follower in
                var followedBy = follower.followers
                followedBy -= 1
                
                var followedArray = follower.followedBy
                followedArray.removeAll(where: {$0==user.login})
                
                
                StorageManager.shared.updateDocument(by: follower.login, fields: ["followedBy": followedArray, "followers": followedBy]) {
                    (user: [RegisteredUser]) in
                }
                
            }
            StorageManager.shared.updateDocument(by: userDB.login, fields: ["meFollowing": alreadyFollowed, "subscriptions": subscribed]) {
                (user: [RegisteredUser]) in
            }
            
        }
    }
    
    // convinience method to like post
    func likePost(docID: String, by: RegisteredUser, completion: @escaping (Post)->Void) {
        let collectionRef = db.collection("Posts")
        let documentRef = collectionRef.document(docID)
        
        
        
        documentRef.getDocument { (documentSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                do {
                    var post = try documentSnapshot!.data(as: Post.self)
                    if !post.likesByUser.contains(by.login) {
                        post.likes += 1
                        post.likesByUser.append(by.login)
                    }
                    else {
                        post.likes -= 1
                        post.likesByUser.removeAll(where: {$0 == by.login})
                    }
                    
                    documentRef.updateData(["likes": post.likes,"likesByUser": post.likesByUser]) { error in
                        completion(post)
                        if let error = error {
                            print("Error updating document: \(error)")
                        }
                    }
                }
                catch {
                    print("Error")
                }
            }
        }
    }
    
    // convinience method to favorite post
    func favoritePost(docID: String, completion: @escaping (Post)->Void) {
        let collectionRef = db.collection("Posts")
        let documentRef = collectionRef.document(docID)
        
        
        
        documentRef.getDocument { (documentSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                do {
                    var post = try documentSnapshot!.data(as: Post.self)
                    post.isFavoritePost.toggle()
                    
                    documentRef.updateData(["isFavoritePost": post.isFavoritePost]) { error in
                        completion(post)
                        if let error = error {
                            print("Error updating document: \(error)")
                        }
                    }
                }
                catch {
                    print("Error")
                }
            }
        }
    }
}







// CoreData manager

import CoreData
import UIKit

final class CoreDManager {

    static let shared = CoreDManager()
    private (set) var posts: [CDPost] = []
    
    private var context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    private init() {
        fetchPosts()
    }
    
    
    // to fetch favorite posts
    func fetchPosts() {
        let fetchRequest = CDPost.fetchRequest()
        posts = (try? context.fetch(fetchRequest)) ?? []
    }
    
    // to save post to favorites
    func savePost(_ post: Post) {
        if posts.filter({$0.toStruct() == post}).isEmpty {
            let _ = post.toCDPost(context: context)
            try? context.save()
            fetchPosts()
        }
    }
    
    // to delete post from favorites
    func deletePost(at index: Int) {
        context.delete(posts[index])
        try? context.save()
        fetchPosts()
    }
    
    // to delete post from favorites
    func deletePostContent(for post: Post) {
        
        var ind = 0
        
        if posts.filter({$0.toStruct() == post}).isEmpty {
            return
        } else {
            ind = posts.firstIndex(where: {$0.toStruct() == post})!
            context.delete(posts[ind])
            try? context.save()
            fetchPosts()
        }
    }
    
}


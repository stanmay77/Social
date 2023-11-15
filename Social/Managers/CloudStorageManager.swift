// Image Cloud storage manager

import FirebaseStorage
import UIKit


final class CloudStorageManager {
    
    static let shared = CloudStorageManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    
    // to upload image
    func uploadImageToCloud(for fileURL: URL, for login: String, avatar: Bool, completion: @escaping (Result<URL,CloudError>)-> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let fileExtension = fileURL.pathExtension
        var fileName = ""
        
        if avatar {
            fileName = "\(login).\(fileExtension)"
        } else {
            fileName = "\(fileURL.lastPathComponent).\(fileExtension)"
        }
        
        let storageReference = Storage.storage().reference().child(fileName)
        
        
        let _ = storageReference.putFile(from: fileURL, metadata: metadata) { meta, error in
            
            if error != nil {
                completion(.failure(.connectionError))
            }
            
            storageReference.downloadURL { (url, error) in
                if error != nil {
                    completion(.failure(.connectionError))
                }
                
                guard let downloadURL = url else {
                                    completion(.failure(.connectionError))
                                    return
                                }
                
                
                if let imageData = try? Data(contentsOf: fileURL),
                    let image = UIImage(data: imageData) {
                    self.cache.setObject(image, forKey: downloadURL.absoluteString as NSString)
                    print("Uploaded image to cache")
                 }
                
                completion(.success(downloadURL))
            }
        }
    }
    
    // to fetch image
    func fetchCloudImage(for fileURL: URL, completion: @escaping (Result<UIImage?,CloudError>)-> Void) {
        
        if let cachedImage = cache.object(forKey: fileURL.absoluteString as NSString) {
            print("loaded image from cache")
            completion(.success(cachedImage))
            return
        }
        
        let task = URLSession.shared.dataTask(with: fileURL) { data, response, error in
            
            if error != nil {
                completion(.failure(.connectionError))
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(.connectionError))
            }
            
            if let data = data,
               let avatarImage = UIImage(data: data) {
                completion(.success(avatarImage))
            } else {
                completion(.failure(.connectionError))
            }
        }
        task.resume()
    }
    
    // to delete image
    func deleteImageFromCloud(for fileURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        
        cache.removeObject(forKey: fileURL.absoluteString as NSString)
        
        let path = fileURL.absoluteString.split(separator: "/", maxSplits: .max, omittingEmptySubsequences: true).dropFirst(5).joined(separator: "/").removingPercentEncoding
        
        guard path != nil else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let storageReference = Storage.storage().reference(forURL: fileURL.absoluteString)
        
        storageReference.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}






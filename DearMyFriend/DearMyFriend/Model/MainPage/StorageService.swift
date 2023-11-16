import UIKit
import FirebaseStorage
import Firebase

class StorageService {
    
    public static let shared = StorageService()
    private init() {}
    
    let storage = Storage.storage()
    var bannerUrl: [Int:String] = [:]
    var storyImage: [PopularityModel] = []
    var storyUrl: [Int:String] = [:]
    var storyCount: Int = 0
    
    
    public func uploadBanner(completion: @escaping (Error?) -> Void) {
        let folder = self.storage.reference().child("Main")
        
        folder.listAll { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
            } else {
                let imageList = result?.items ?? []
                let dispatchGroup = DispatchGroup()
                
                for (index,item) in imageList.enumerated() {
                    dispatchGroup.enter()
                    
                    item.downloadURL { url, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let error = error {
                            completion(error)
                        } else if let url = url {
                            self.bannerUrl.updateValue(url.absoluteString, forKey: index+1)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(nil)
                }
                
            }
        }
    }
    
    public func uploadStory(completion: @escaping (Error?) -> Void) {
        self.storyUrl = [:]
        
        let folder = self.storage.reference().child("Story")
        
        folder.listAll { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
            } else {
                let imageList = result?.items ?? []
                let dispatchGroup = DispatchGroup()
                
                for (index,item) in imageList.enumerated() {
                    dispatchGroup.enter()
                    
                    item.downloadURL { url, error in
                        defer {
                            dispatchGroup.leave()
                        }
                        if let error = error {
                            completion(error)
                        } else if let url = url {
                            self.storyUrl.updateValue(url.absoluteString, forKey: index)
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(nil)
                }
            }
        }
    }
    
    public func bringStoryImage(completion: @escaping ([PopularityModel]?, Error?) -> Void) {
        self.storyImage = []
        self.getStoryData { error in
            if error != nil {
                completion(nil, error)
                return
            }
            self.getStoryImage { [weak self] error in
                guard let self = self else { return }
                
                if error != nil {
                    completion(nil, error)
                    return
                }
                completion(self.storyImage, nil)
            }
        }
    }
    
    
    private func getStoryData(completion: @escaping (Error?) -> Void) {
        let store = Firestore.firestore().collection("Feeds").order(by: "likeCount", descending: true).limit(to: 5)
        
        store.getDocuments { [weak self] query, error in
            guard let self = self else { return }
            if error != nil {
                completion(error)
                return
            }
            
            guard let query = query else { return }
            
            
            for item in query.documents.enumerated() {
                if let images = item.element["imageUrl"] as? [String] {
                    let popularityImage = PopularityModel(imageUrl: images.first)
                    
                    self.storyImage.append(popularityImage)
                }
            }
            
            completion(nil)
        }
    }
    
    private func getStoryImage(completion:@escaping (Error?) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        for item in storyImage.enumerated() {
            var imageInfo = self.storyImage[item.offset]
            let index = item.offset
            dispatchGroup.enter()
            guard let imageUrls = item.element.imageUrl else { return }
            
            loadImage(imageUrls) { [weak self] image, error in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                
                if error != nil {
                    completion(error)
                    return
                }
                
                imageInfo.image = image
                self.storyImage[index] = imageInfo
            }
            
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(nil)
        }
    }
    
    private func loadImage(_ url: String?, completion:@escaping (UIImage? ,Error?) -> Void) {
        guard let imageUrl = url, let downloadUrl = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: downloadUrl) { (data, response, error) in
            
            if error != nil {
                completion(nil ,error)
                return
            }
            
            guard let safeData = data else {
                completion(nil, error)
                return
            }
            
            guard let image = UIImage(data: safeData) else {
                completion(nil, error)
                return
            }
            
            completion(image, nil)
            
        }.resume()
    }
}

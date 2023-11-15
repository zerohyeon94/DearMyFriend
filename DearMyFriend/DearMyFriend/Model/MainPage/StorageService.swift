import UIKit
import FirebaseStorage

class StorageService {
    
    public static let shared = StorageService()
    private init() {}
    
    let storage = Storage.storage()
    var bannerUrl: [Int:String] = [:]
    var storyUrl: [Int:String] = [:]
    var storyCount: Int = 0
    
    
    public func uploadBanner(completion: @escaping (Error?) -> Void) {
        print("---------------------------배너 업데이트 시작---------------------------")
        let folder = self.storage.reference().child("Main")
        
        folder.listAll { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                print(error.localizedDescription)
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
                            print(error.localizedDescription)
                        } else if let url = url {
                            self.bannerUrl.updateValue(url.absoluteString, forKey: index+1)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(nil)
                    print("배너 불러오기 성공")
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
}

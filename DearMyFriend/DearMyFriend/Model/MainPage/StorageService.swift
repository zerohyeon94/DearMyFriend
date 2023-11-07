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
        self.bannerUrl = [:]
        let folder = self.storage.reference().child("Main")
        
        folder.listAll { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
            } else {
                let imageList = result?.items ?? []
                let dispatchGroup = DispatchGroup()
                
                for (index,item) in imageList.enumerated() {
                    print(index)
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
}


//public func uploadStory(completion: @escaping (Error?) -> Void) {
//    self.storyUrl = []
//    
//    let folder = self.storage.reference().child("Story")
//    
//    folder.listAll { [weak self] result, error in
//        guard let self = self,
//              let imageList = result?.items else { return }
//        
//        if let error = error {
//            completion(error)
//        } else {
//            var downloadCount = 0
//            
//            for item in imageList {
//                item.downloadURL { url, error in
//                    downloadCount += 1
//                    // 이전에는 반복주기의 끝과 같다면 바로 completion을 호출했음
//                    // 그럼 반복문이 전부 완료되고 한개의 이미지만 다운받아지더라도 completion이 호출됨
//                    // 하지만 downloadURL는 오래걸리는 작업이며
//                    // 반복주기의 끝에서도 downloadUrl은 계속 진행되고 있음
//                    // 그럼으로 이미지 다운로드가 완료된 시점에만 카운트를 올려줌
//                    
//                    if let error = error {
//                        if downloadCount == imageList.count {
//                            completion(error)
//                        }
//                    } else {
//                        guard let bannerLink = url?.absoluteString else {
//                            if downloadCount == imageList.count {
//                                completion(error)
//                            }
//                            return
//                        }
//                        self.storyUrl.append(bannerLink)
//                        
//                        if downloadCount == imageList.count {
//                            print("완료시점", imageList.count)
//                            completion(nil)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

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
                        // defer의 역할 : 클로저 내의 모든 작업이 종료된 다음 무조건적으로 실행되는 코드
                        // 여기서 defer의 역할?
                        // dispatchGroup을 첫번째에 클로저의 첫 실행으로 하면 딕셔너리의 마지막 업데이트가 이루어지지 않았는데 completion(nil)이 보내진다.
                        // dispatchGroup을 마지막에 둔다면 에러가 난 경우에는 실행되지 않음으로 dispatchGroup.notify가 실행되지 않는다.
                        // 고로 어떤 상황에서든 클로저의 작업이 마무리되는 시점에 무조건적으로 실행시켜주는 defer의 내부에서 dispatchGroup.leave()를 실행시켜주는 것
                        
                        // 요약 : 모든 데이터의 다운로드가 완료되는 시점은 DispatchGroup의 dispatchGroup.notify 클로저 내에서 completion(nil)이 호출되는 시점과 일치
                        // 이것은 모든 이미지의 URL을 self.bannerUrl 딕셔너리에 안전하게 업데이트한 후에 completion 클로저를 호출하는 안정적인 방법입니다.
                        
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

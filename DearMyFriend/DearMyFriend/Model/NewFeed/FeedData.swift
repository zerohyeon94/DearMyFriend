import UIKit
import Firebase
import FirebaseStorage

enum ConversionImageError: Error {
    case dataError
    case networkError
    case conversionError
    case authenticationError
}

enum BringFeed {
    case basic
    case additional
}

class FeedService {
    
    public static let shared = FeedService()
    private init() {}
    
    typealias ConversionCompletion = (Result<UIImage, ConversionImageError>) -> Void
    
    typealias bringPostCompletion = (Result<[NewFeedModel], ConversionImageError>) -> Void
    
    typealias dbCompletion = (Result<Void, ConversionImageError>) -> Void
    
    typealias likePostCompletion = (Result<[String], ConversionImageError>) -> Void
    
    private var lastDocument:QueryDocumentSnapshot?
    
    public var feeds: [NewFeedModel] = []
    
    // MARK: - Post Main Method
    public func getFeed(_ type: BringFeed, completion:@escaping bringPostCompletion) {
        
        self.getFeedData(type) { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            self.filterExcludedPost()
            
            self.filterExcludedPostOfUser { error in
                if error != nil {
                    completion(.failure(.networkError))
                    return
                }
                
                self.filterLikedPostOfUser { error in
                    if error != nil {
                        completion(.failure(.networkError))
                        return
                    }
                    
                    self.userInfoBasedOnUid { [weak self] error in
                        guard let self = self else { return }
                        
                        if error != nil {
                            completion(.failure(.networkError))
                            return
                        }
                        
                        let dispatchGroup = DispatchGroup()
                        
                        dispatchGroup.enter()
                        self.getProfileImage {
                            dispatchGroup.leave()
                        }
                        
                        dispatchGroup.enter()
                        self.getFeedImage {
                            dispatchGroup.leave()
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            completion(.success(self.feeds))
                        }
                    }
                }
            }
        }
    }
    
    public func reportFeed(_ documentID: String, completion:@escaping dbCompletion) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.reportDataUpdateFeedDB(documentID) { result in
            switch result {
            case .success():
                dispatchGroup.leave()
            case .failure(let error):
                completion(.failure(.networkError))
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        self.reportDataUpdateUserDB(documentID) { result in
            switch result {
            case .success():
                dispatchGroup.leave()
            case .failure(let error):
                completion(.failure(.networkError))
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    public func checkLike(_ likeBool: Bool, _ index: Int, _ documentID: String, completion: @escaping dbCompletion) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        if likeBool {
            self.cancelLike(documentID) { result in
                switch result {
                case .success():
                    dispatchGroup.leave()
                case .failure(_):
                    completion(.failure(.networkError))
                }
            }
        } else {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.likedFeed(index, documentID) { result in
            switch result {
            case .success():
                dispatchGroup.leave()
            case .failure(_):
                completion(.failure(.networkError))
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    // MARK: - Post Updata Method
    private func getFeedData(_ type: BringFeed, completion: @escaping (Error?) -> Void) {
        var store = Firestore.firestore().collection("Feeds").order(by: "date", descending: true).limit(to: 5)
        
        switch type {
            
        case .basic:
            self.feeds = []
        case .additional:
            if let lastDocument = self.lastDocument {
                store = Firestore.firestore().collection("Feeds").order(by: "date", descending: true).start(afterDocument: lastDocument).limit(to: 5)
            }
        }
        
        store.getDocuments { [weak self] query, error in
            guard let self = self else { return }
            if error != nil {
                completion(error)
                return
            }
            
            guard let query = query else { return }
            
            let feedCount = query.documents.count
            
            for item in query.documents.enumerated() {
                let documentID = item.element.documentID
                
                let reportCount = item.element["reportCount"] as? Int ?? 0
                
                if let uid = item.element["uid"] as? String,
                   let post = item.element["post"] as? String,
                   let images = item.element["imageUrl"] as? [String],
                   let likeCount = item.element["likeCount"] as? Int {
                    let feed = NewFeedModel(uid: uid,
                                            image: images,
                                            post: post,
                                            documentID: documentID,
                                            reportCount: reportCount,
                                            likeCount: likeCount)
                    self.feeds.append(feed)
                }
                
                print("문서 식별자 : \(item.element.documentID)")
                if item.offset == feedCount-1 {
                    self.lastDocument = item.element
                }
            }
            
            completion(nil)
        }
    }
    
    private func filterExcludedPost() {
        self.feeds.removeAll { result in
            guard let count = result.reportCount else { return false }
            
            if count >= 3 {
                return true
            } else {
                return false
            }
        }
    }
    
    private func filterExcludedPostOfUser(completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userDB = Firestore.firestore().collection("Users").document(uid)
        
        userDB.getDocument { [weak self] qs, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }

            guard let qs = qs, qs.exists else {
                completion(error)
                return
            }
            
            let blockedDocuments = qs.data()?["blockedDocuments"] as? [String] ?? []
            
            for document in blockedDocuments {
                self.feeds.removeAll { $0.documentID == document }
            }
            
            completion(nil)
        }
    }
    
    public func checkLastPost(completion: @escaping (Bool, Error?) -> Void) {
        
        guard let myLastDocument = self.lastDocument else { return }
        
        let store = Firestore.firestore().collection("Feeds").order(by: "date", descending: false).limit(to: 1)
        
        store.getDocuments { query, error in
            
            if error != nil {
                completion(false, error)
                return
            }
            
            guard let oldDocument = query?.documents.first else { return }
            
            if oldDocument == myLastDocument {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    private func userInfoBasedOnUid(completion: @escaping (Error?) -> Void) {
        print("유저정보 업데이트")
        
        let store = Firestore.firestore().collection("Users")
        
        let dispatchGroup = DispatchGroup()
        
        for item in feeds.enumerated() {
            
            guard let uid = item.element.uid else { return}
            
            if item.element.userName == nil {
                dispatchGroup.enter()
                
                let userInfo = store.document(uid)
                
                userInfo.getDocument { [weak self] document, error in
                    defer { dispatchGroup.leave() }
                    
                    guard let self = self else { return }
                    
                    if error != nil {
                        completion(error)
                        return
                    }
                    
                    guard let itemDocument = document, itemDocument.exists else { return }
                    
                    if let userName = itemDocument["username"] as? String,
                       let userImage = itemDocument["photoUrl"] as? String {
                        self.feeds[item.offset].userName = userName
                        self.feeds[item.offset].profileImageUrl = userImage
                        
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(nil)
        }
    }
    
    private func getProfileImage(completion:@escaping () -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        for item in feeds.enumerated() {
            if item.element.profileImage == nil {
                dispatchGroup.enter()
                
                let imageUrl = item.element.profileImageUrl
                
                self.loadImage(imageUrl) { [weak self] result in
                    defer { dispatchGroup.leave() }
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let image):
                        self.feeds[item.offset].profileImage = image
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.feeds[item.offset].profileImage = UIImage()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private func getFeedImage(completion:@escaping () -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        for item in feeds.enumerated() {
            if item.element.feedImages.isEmpty {
                
                guard let imageUrls = item.element.image else { return }
                
                for imageUrl in imageUrls.enumerated() {
                    dispatchGroup.enter()
                    loadImage(imageUrl.element) { [weak self] result in
                        defer { dispatchGroup.leave() }
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let image):
                            self.feeds[item.offset].feedImages.updateValue(image, forKey: imageUrl.offset)
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.feeds[item.offset].feedImages.updateValue(UIImage(), forKey: imageUrl.offset)
                        }
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private func loadImage(_ url: String?, completion:@escaping ConversionCompletion) {
        guard let imageUrl = url, let downloadUrl = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: downloadUrl) { (data, response, error) in
            
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            guard let image = UIImage(data: safeData) else {
                completion(.failure(.conversionError))
                return
            }
            
            completion(.success(image))
            
        }.resume()
    }
    
    // MARK: - Post Report Method
    
    private func reportDataUpdateFeedDB(_ documentID: String, completion:@escaping dbCompletion) {
        let db = Firestore.firestore().collection("Feeds").document(documentID)
        
        db.getDocument { document, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            if let document = document, document.exists {
                if var data = document.data() {
                    if let reportCount = data["reportCount"] as? Int {
                        data["reportCount"] = reportCount + 1
                    } else  {
                        data["reportCount"] = 1
                    }
                    
                    db.setData(data, merge: true) { error in
                        if error != nil {
                            completion(.failure(.networkError))
                            return
                        }
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    private func reportDataUpdateUserDB(_ documentID: String, completion: @escaping dbCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        
        let userRef = Firestore.firestore().collection("Users").document(uid)
        
        userRef.updateData(["blockedDocuments": FieldValue.arrayUnion([documentID])]) { error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // MARK: - Post Like Filter Method
    
    // FeedDB Control Method
    private func likedFeed(_ index: Int, _ documentID: String, completion:@escaping dbCompletion) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.likeCountUpdateFeedDB(index, documentID) { result in
            switch result {
            case .success():
                dispatchGroup.leave()
            case .failure(let error):
                completion(.failure(.networkError))
                print(error.localizedDescription)
                return
            }
        }
        
        dispatchGroup.enter()
        self.likeDataUpdateUserDB(documentID) { result in
            switch result {
            case .success():
                dispatchGroup.leave()
            case .failure(let error):
                completion(.failure(.networkError))
                print(error.localizedDescription)
                return
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    // UserDB Control Method
    private func cancelLike(_ documentID: String, completion:@escaping dbCompletion) {
        self.fetchLikeList(documentID) { result in
            switch result {
            case .success(let likePostList):
                self.deleteLikePost(likePostList: likePostList) { error in
                    if error != nil {
                        completion(.failure(.networkError))
                        return
                    }
                    completion(.success(()))
                }
            case .failure(_):
                completion(.failure(.networkError))
            }
        }
    }
    
    // LikeCount UP : DB에 접근해서 해당 게시글의 LikeCount 변경
    private func likeCountUpdateFeedDB(_ index: Int, _ documentID: String, completion:@escaping dbCompletion) {
        let db = Firestore.firestore().collection("Feeds").document(documentID)
        
        db.getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            if let document = document, document.exists {
                if var data = document.data() {
                    if let likeCount = data["likeCount"] as? Int {
                        
                        if !self.feeds[index].likeBool {
                            data["likeCount"] = likeCount + 1
                            self.feeds[index].likeBool = true
                        } else {
                            data["likeCount"] = likeCount - 1
                            self.feeds[index].likeBool = false
                        }
                    }
                    
                    
                    db.setData(data, merge: true) { error in
                        if error != nil {
                            completion(.failure(.networkError))
                            return
                        }
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    // LikePost 추가 : Users(uid)의 LikeDocuments list에 추가
    private func likeDataUpdateUserDB(_ documentID: String, completion: @escaping dbCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        
        let userRef = Firestore.firestore().collection("Users").document(uid)
        
        userRef.updateData(["likedDocuments": FieldValue.arrayUnion([documentID])]) { error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // LikePost 삭제 1번 : Users(uid)의 LikeDocuments list에서 삭제 후 리스트[String] 리턴
    private func fetchLikeList(_ documentID: String, completion: @escaping likePostCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likePostDB = Firestore.firestore().collection("Users").document(uid)
        
        likePostDB.getDocument { qs, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            guard let qs = qs, qs.exists else {
                completion(.failure(.dataError))
                return
            }
            
            var likePostList = qs.data()?["likedDocuments"] as? [String] ?? []
            
            if let index = likePostList.firstIndex(of: documentID) {
                likePostList.remove(at: index)
                completion(.success(likePostList))
            } else {
                completion(.failure(.conversionError))
            }
        }
    }
    
    // LikePost 삭제 2번 : 1번에서 삭제한 뒤 넘겨준 리스트로 업데이트
    private func deleteLikePost(likePostList: [String], completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likePostDB = Firestore.firestore().collection("Users").document(uid)
        
        likePostDB.updateData(["likedDocuments": likePostList]) { error in
            if error != nil {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    // 데이터 받아올 때 사용 : Users(uid)에 포함되어 있는지 체크
    private func filterLikedPostOfUser(completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userDB = Firestore.firestore().collection("Users").document(uid)
        
        userDB.getDocument { [weak self] qs, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }

            guard let qs = qs, qs.exists else {
                completion(error)
                return
            }
            
            let likedDocuments = qs.data()?["likedDocuments"] as? [String] ?? []
            
            for document in likedDocuments {
                if let index = self.feeds.firstIndex(where: { $0.documentID == document }) {
                    self.feeds[index].likeBool = true
                }
            }
            completion(nil)
        }
    }
}




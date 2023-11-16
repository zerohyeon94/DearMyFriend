import UIKit
import Firebase
import FirebaseStorage

enum ConversionCommentError: Error {
    case dataError
    case networkError
    case conversionError
    case authenticationError
}

class CommentService {
    
    public static let shared = CommentService()
    private init() {}
    
    typealias DBCompletion = (Result<Void, ConversionCommentError>) -> Void
    typealias CommentCompletion = (Result<[CommentModel], ConversionCommentError>) -> Void
    typealias ConversionCompletion = (Result<UIImage, ConversionImageError>) -> Void
    
    public var comments: [CommentModel] = []
    
    // MARK: - Post Updata Method
    public func getComment(_ documentID: String, completion: @escaping CommentCompletion) {
        self.comments = []
        self.getDBData(documentID) { result in
            switch result {
            case .success():
                self.userInfoBasedOnUid { error in
                    if error != nil {
                        completion(.failure(.networkError))
                        return
                    }
                    self.getProfileImage { error in
                        if error != nil {
                            completion(.failure(.networkError))
                            return
                        }
                        let reversedComment = self.comments.reversed()
                        let commentArray = Array(reversedComment)
                        completion(.success(commentArray))
                    }
                }
            case .failure(_):
                completion(.failure(.networkError))
            }
        }
    }
    
    
    private func getDBData(_ documentID: String, completion: @escaping DBCompletion) {
        let store = Firestore.firestore().collection("Feeds").document(documentID)
        
        store.getDocument { [weak self] query, error in
            guard let self = self else { return }
            
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            guard let query = query, query.exists else {
                completion(.failure(.dataError))
                return
            }
            
            let commentDocuments = query.data()?["comment"] as? [[String:String]] ?? [[:]]
            
            for document in commentDocuments {
                
                let uid = document.first?.key ?? ""
                let text = document.first?.value ?? ""
                
                let comment = CommentModel(comment: text, uid: uid)
                self.comments.append(comment)
            }
            completion(.success(()))
        }
    }
    
    private func userInfoBasedOnUid(completion: @escaping (Error?) -> Void) {
        
        let store = Firestore.firestore().collection("Users")
        
        let dispatchGroup = DispatchGroup()
        
        for item in comments.enumerated() {
            
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
                        self.comments[item.offset].userName = userName
                        self.comments[item.offset].imageUrl = userImage
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(nil)
        }
    }
    
    private func getProfileImage(completion:@escaping (Error?) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        for item in comments.enumerated() {
            if item.element.profileImage == nil {
                dispatchGroup.enter()
                
                let imageUrl = item.element.imageUrl
                
                self.loadImage(imageUrl) { [weak self] result in
                    defer { dispatchGroup.leave() }
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let image):
                        self.comments[item.offset].profileImage = image
                    case .failure(let error):
                        self.comments[item.offset].profileImage = UIImage()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(nil)
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
    
    public func commentDataUpdateDB(_ comment: String ,_ documentID: String, completion: @escaping DBCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        
        let userComment = [uid:comment]
        
        let userRef = Firestore.firestore().collection("Feeds").document(documentID)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(.networkError))
                return
            }
            
            if let data = document?.data(), var currentComments = data["comment"] as? [[String: String]] {
                currentComments.append(userComment)
                
                userRef.updateData(["comment": currentComments]) { error in
                    if let error = error {
                        completion(.failure(.networkError))
                        return
                    }
                    completion(.success(()))
                }
            } else {
                completion(.failure(.dataError))
            }
        }
    }
    
    public func reportComment(_ comment: String,_ documentID: String, completion: @escaping DBCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.authenticationError))
            return
        }
        
        let reportData = ReportCommentModel(uid: uid, documentID: documentID, comment: comment).toFirestoreData()
        
        let userRef = Firestore.firestore().collection("ReportComment").document()
        
        userRef.setData(reportData) { error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            completion(.success(()))
        }
    }
}

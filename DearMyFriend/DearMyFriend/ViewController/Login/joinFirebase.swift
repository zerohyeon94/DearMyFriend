////
////  loginFirebase.swift
////  DearMyFriend
////
////  Created by 정일한 on 10/26/23.
////
//
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//final class UserFireStore {
//    
//    private var documentListener: ListenerRegistration?
//    
//    let collectionUsers = "Users"
//    let collectionInfo = "Info"
//    let collectionFeed = "Feed"
//    
//    
//    
//    func saveUserInfo(userData: UserData, completion: ((Error?) -> Void)? = nil) {
//        let collectionPath = "\(collectionUsers)" //Users
//        let collectionListener = Firestore.firestore().collection(collectionPath)
//        
//        guard let dictionary = userData.asDictionary else { // Firestore에 저장 가능한 형식으로 변환할 수 잇는 dictionary
//            print("decode error")
//            return
//        }
//        // document : 사용자의 이름(userData.id)
//        collectionListener.document("\(userData.id)").setData(dictionary){ error in // Firestore Collection에 데이터를 추가.
//            completion?(error)
//        }
//    }
//    
//    
//    func saveUserFeed(feedData: FeedData, completion: ((Error?) -> Void)? = nil) {
//        let collectionDocumentPath = "\(collectionUsers)"
//        let collectionDocumentListener = Firestore.firestore().collection(collectionDocumentPath)
//        // document 생성
//        collectionDocumentListener.document("\(feedData.id)").setData(["id":"\(feedData.id)"]) { error in
//            if let error = error {
//                print("Error adding document: \(error)")
//            } else {
//                print("Document added successfully!")
//            }
//        }
//    }
//}

//
//  FeedFirebase.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class MyFirestore {
    
    let collectionUsers = "Users"
    let collectionInfo = "Info"
    let collectionFeed = "Feeds"
    
    func getCurrentUser() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
    func getCurrentUserEmail() -> String? {
        if let user = Auth.auth().currentUser {
            return user.email
        } else {
            return nil
        }
    }
    
    func getUsername(uid: String, completion: @escaping (String) -> Void) {
        var username: String = ""
        
        let documentPath = "\(collectionUsers)/\(uid)"
        removeListener()
        
        let documentListener = Firestore.firestore().document(documentPath).addSnapshotListener { documentSnapshot, error in
            if let error = error {
            } else {
                let data = documentSnapshot?.data()
                if let name = data?["username"] as? String {
                    username = name
                }
            }
            completion(username)
        }
    }
    
    func getUserProfile(uid: String, completion: @escaping (String) -> Void) {
        var profileURL: String = ""
        
        let documentPath = "\(collectionUsers)/\(uid)"
        removeListener()
        
        let documentListener = Firestore.firestore().document(documentPath).addSnapshotListener { documentSnapshot, error in
            if let error = error {
            } else {
                let data = documentSnapshot?.data()
                if let url = data?["photoUrl"] as? String {
                    profileURL = url
                }
            }
            completion(profileURL)
        }
    }
    
    private var documentListener: ListenerRegistration? // 데이터 변경 이벤트를 수신하기 위한 리스너의 등록과 해제를 관리하는 역할. (데이터의 실시간 업데이트)


    func removeListener() {
        documentListener?.remove()
    }

}

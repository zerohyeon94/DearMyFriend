import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    
    public func photoUpdate(email: String?, photo: UIImage?, completion: @escaping (Error?) -> Void ) {
        
        guard let email = email,
              let photo = photo else { return }
        
        let storageRef = Storage.storage().reference().child("UserProfile/\(email)/profile.jpg")
        
        guard let uploadImage = photo.jpegData(compressionQuality: 0.5) else {
            print("업로드 에러")
            return
        }
        
        storageRef.putData(uploadImage) { (_, error) in
            completion(nil)
        }
        
    }
    
    public func getPhotoUrl(email: String?, completion: @escaping (String?, Error?) -> Void) {
        
        guard let email = email else { return }
        
        let folder = Storage.storage().reference().child("UserProfile/\(email)")
        
        folder.listAll { result, error in
            if let error = error {
                completion(nil, error)
                return
            } else {
                let profileImageRef = result?.items.first { $0.name == "profile.jpg"}
                guard let profileImageRef = profileImageRef else {
                    completion(nil, error)
                    return
                }
                profileImageRef.downloadURL { url, error in
                    if let error = error {
                        completion(nil, error)
                        return
                    } else if let url = url {
                        completion(url.absoluteString, nil)
                        return
                    }
                }
            }
        }
    }
    
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?)->Void) {
        
        guard let username = userRequest.username,
              let email = userRequest.email,
              let password = userRequest.password,
              let agreeMent = userRequest.agreeMent,
              let photoUrl = userRequest.photoUrl else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("Users").document(resultUser.uid).setData([
                "username": username,
                "email": email,
                "agreeMent": agreeMent,
                "photoUrl": photoUrl
            ]) { error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
            }
        }
    }
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Bool, Error?)->Void) {
        Auth.auth().signIn(withEmail: userRequest.email,password: userRequest.password) { result, error in
            if let error = error {
                completion(false, error)
                return
            } else {
                guard let certificationCheck = Auth.auth().currentUser?.isEmailVerified else { return }
                completion(certificationCheck, nil)
            }
        }
    }
    
    public func certificationCheck(completion: @escaping (Error?)->Void ){
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        })
    }
    
    public func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    public func resetPassword(with code: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().confirmPasswordReset(withCode: code, newPassword: newPassword) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    public func changeController(_ controller: UIViewController) {
        if let sceneDelegate = controller.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication(opacity: 0)
        }
    }
    
    public func deleteAccount(completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error = error {
                completion(error)
                return
            }
            
            let folder = Storage.storage().reference().child("UserProfile/\(email)")
            folder.listAll { result, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let allItem = result?.items else { return }
                for item in allItem {
                    item.delete { error in
                        if let error = error {
                            completion(error)
                        } else {
                            Firestore.firestore().collection("Users").document(uid).delete()
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    public func emailCheck(email: String, completion: @escaping (Bool, Error?) -> Void) {
        let emailDB = Firestore.firestore().collection("Users")
        
        let query = emailDB.whereField("email", isEqualTo: email)
        query.getDocuments { qs, error in
            if let error = error {
                completion(false, error)
            }
            
            guard let qs = qs else { return completion(false, error) }
            
            if qs.documents.isEmpty {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
}


//public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
//    guard let userUID = Auth.auth().currentUser?.uid else { return }
//
//    let db = Firestore.firestore()
//
//    db.collection("users")
//        .document(userUID)
//        .getDocument { snapshot, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//
//            if let snapshot = snapshot,
//               let snapshotData = snapshot.data(),
//               let username = snapshotData["username"] as? String,
//               let email = snapshotData["email"] as? String {
//                let user = User(username: username, email: email, userUID: userUID)
//                completion(user, nil)
//            }
//
//        }
//}

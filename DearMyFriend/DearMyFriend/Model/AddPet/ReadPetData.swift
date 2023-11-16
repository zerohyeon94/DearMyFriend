import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PetDataService {
    
    public static let shared = PetDataService()
    private init() {}
    
    typealias Networkcompletion = (Result<[RegisterMyPetInfo], NetworkError>) -> Void
    
    private var allPet: [RegisterMyPetInfo] = []
    
    public func uploadPetInfo(completion: @escaping Networkcompletion) {
        guard let loginUser = Auth.auth().currentUser?.uid else { return }
        
        let userDB = Firestore.firestore().collection("Users")
        let petDB = userDB.document(loginUser).collection("Pet")
        
        petDB.getDocuments { [weak self] query, error in
            guard let self = self else { return }
            if error != nil {
                completion(.failure(.dataError))
                return
            }
            guard let allList = query?.documents else {
                completion(.failure(.networkingError))
                return
            }
            
            for item in allList {
                if let name = item["name"] as? String,
                   let age = item["age"] as? String,
                   let spices = item["spices"] as? String,
                   let photoUrl = item["photo"] as? String {
                    let myPet = RegisterMyPetInfo(name: name, age: age, type: spices, photoUrl: photoUrl)
                    self.allPet.append(myPet)
                }
            }
            completion(.success(self.allPet))
        }
    }
}
